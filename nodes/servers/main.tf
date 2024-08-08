data "oci_core_images" "golden_image" {
  compartment_id = var.compartment_ocid

  sort_by    = "TIMECREATED"
  sort_order = "DESC"

  filter {
    name = "display_name"
    values = [
      "^golden-image-([TZ0-9-:]+)$",
    ]
    regex = true
  }
}

data "oci_core_images" "ubuntu" {
  compartment_id = var.compartment_ocid

  sort_by    = "TIMECREATED"
  sort_order = "DESC"

  filter {
    name = "display_name"
    values = [
      "^Canonical-Ubuntu-22.04-aarch64-([\\.0-9-]+)$",
    ]
    regex = true
  }
}

resource "oci_core_instance_configuration" "server" {
  compartment_id = var.compartment_ocid

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = var.compartment_ocid

      instance_options {
        are_legacy_imds_endpoints_disabled = false # vault CLI uses IMDSv1
      }

      create_vnic_details {
        assign_private_dns_record = true
        assign_public_ip          = true
      }

      metadata = {
        ssh_authorized_keys = file("./certificates/ssh-key-2024-03-16.key.pub")
      }

      shape = var.shape
      shape_config {
        memory_in_gbs = 6
        ocpus         = 1
      }

      is_pv_encryption_in_transit_enabled = true

      source_details {
        image_id = (length(data.oci_core_images.golden_image.images[*].id) != 0 ?
        data.oci_core_images.golden_image.images[0].id : data.oci_core_images.ubuntu.images[0].id)
        source_type = "image"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_core_instance_pool" "servers" {
  compartment_id            = var.compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.server.id
  size                      = length(var.availability_domains)

  dynamic "placement_configurations" {
    for_each = var.availability_domains
    content {
      availability_domain = placement_configurations.value
      primary_subnet_id   = oci_core_subnet.servers.id
    }
  }

  load_balancers {
    backend_set_name = oci_load_balancer_backend_set.internal.name
    load_balancer_id = oci_load_balancer_load_balancer.internal.id
    port             = 6443
    vnic_selection   = "PrimaryVnic"
  }
  load_balancers {
    backend_set_name = oci_load_balancer_backend_set.vault.name
    load_balancer_id = oci_load_balancer_load_balancer.internal.id
    port             = 8200
    vnic_selection   = "PrimaryVnic"
  }
}

resource "oci_identity_dynamic_group" "servers" {
  compartment_id = var.compartment_ocid
  name           = "servers"
  description    = "Grouping all servers"
  matching_rule  = "ALL {instance.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_policy" "compute_instances_list" {
  compartment_id = var.compartment_ocid
  name           = "compute-instances-list"
  description    = "Listing compute instances in servers pool"
  statements = [
    # listing compute instances in user-data script for machine image
    "allow dynamic-group ${oci_identity_dynamic_group.servers.name} to inspect instances in compartment id ${var.compartment_ocid}",
    # using OCI KMS service to get key for vault auto-unsealing
    # https://developer.hashicorp.com/vault/docs/configuration/seal/ocikms#authentication
    "allow dynamic-group ${oci_identity_dynamic_group.servers.name} to use keys in compartment id ${var.compartment_ocid}",
  ]
}
