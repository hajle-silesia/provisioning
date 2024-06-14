resource "oci_core_default_security_list" "internal" {
  compartment_id             = var.compartment_ocid
  manage_default_resource_id = var.network_default_security_list_id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = 6  # TCP
    source = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "all"
    source   = var.network_cidr_range
  }
}
