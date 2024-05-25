data "oci_core_images" "data" {
  compartment_id = var.compartment_ocid

  sort_by    = "TIMECREATED"
  sort_order = "DESC"

  filter {
    name   = "display_name"
    values = [
      "^golden-image-([TZ0-9-:]+)$"
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
        are_legacy_imds_endpoints_disabled = true
      }

      create_vnic_details {
        assign_private_dns_record = true
        assign_public_ip          = true
        nsg_ids                   = [
          var.nsg_id,
        ]
      }

      metadata = {
        ssh_authorized_keys = file("./certificates/ssh-key-2024-03-16.key.pub")
        user_data           = base64encode(file("./nodes/servers/create-server.sh"))
      }

      shape = var.shape
      shape_config {
        memory_in_gbs = 6
        ocpus         = 1
      }

      is_pv_encryption_in_transit_enabled = true

      source_details {
        image_id    = data.oci_core_images.data.images[0].id
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

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [
      oci_core_instance_configuration.server,
    ]
  }
}

data "oci_core_instance_pool_instances" "servers" {
  compartment_id   = var.compartment_ocid
  instance_pool_id = oci_core_instance_pool.servers.id
}

data "oci_core_instance" "data" {
  instance_id = data.oci_core_instance_pool_instances.servers.instances[count.index].id
  count       = length(var.availability_domains)
}
