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
        are_legacy_imds_endpoints_disabled = true
      }

      create_vnic_details {
        assign_private_dns_record = true
        assign_public_ip          = true
      }

      metadata = {
        ssh_authorized_keys = var.instance.instance_public_key
        user_data = base64encode(<<-EOT
            #!/usr/bin/env bash

            LOGFILE="/root/oci-user-data.log"
            set -eo pipefail
            exec 3>&1 4>&2 1>"$${LOGFILE}" 2>&1
            trap "echo 'ERROR: An error occurred during execution, check log $${LOGFILE} for details.' >&3" ERR
            trap '{ set +x; } 2>/dev/null; echo -n "[$(date -uIs)] "; set -x' DEBUG

            export VAULT_NAME="${module.vault_reference.outputs.name}"
            export SECRET_NAME="${module.vault_reference.outputs.secret_name}"
            export COMPARTMENT_OCID="${var.compartment_ocid}"
            export K3S_VERSION="${var.instance.k3s_version}"
            export K3S_TOKEN="${var.k3s_token}"
            export INTERNAL_LB="${module.dns_nlb_reference.outputs.domain_name}"
            export EXTERNAL_LB="${module.dns_alb_reference.outputs.domain_name}"

            . /root/user-data.sh

          EOT
        )
      }

      shape = var.instance.shape
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

data "oci_identity_availability_domains" "main" {
  compartment_id = var.compartment_ocid
}

resource "oci_core_instance_pool" "servers" {
  compartment_id            = var.compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.server.id
  size                      = length(data.oci_identity_availability_domains.main.availability_domains)

  dynamic "placement_configurations" {
    for_each = data.oci_identity_availability_domains.main.availability_domains
    content {
      availability_domain = placement_configurations.value.name
      primary_subnet_id   = module.vcn_reference.outputs.subnet_id
    }
  }

  load_balancers {
    backend_set_name = module.alb_listener_reference.outputs.backend_set_name
    load_balancer_id = module.alb_reference.outputs.id
    port             = 6443
    vnic_selection   = "PrimaryVnic"
  }
  # load_balancers {
  #   backend_set_name = "https-test"
  #   load_balancer_id = module.alb_reference.outputs.id
  #   port             = 80
  #   vnic_selection   = "PrimaryVnic"
  # }
  load_balancers {
    backend_set_name = module.nlb_reference.outputs.backend_set_name
    load_balancer_id = module.nlb_reference.outputs.id
    port             = 6443
    vnic_selection   = "PrimaryVnic"
  }
}
