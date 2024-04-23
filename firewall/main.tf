resource "oci_core_network_security_group" "default" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.network_id
}

# resource "oci_core_network_security_group_security_rule" "ssh" {
#   network_security_group_id = oci_core_network_security_group.ssh.id
#   direction                 = "INGRESS"
#   protocol                  = 6  # TCP
#   source_type               = "CIDR_BLOCK"
#   source                    = "0.0.0.0/0"
#   tcp_options {
#     destination_port_range {
#       min = 22
#       max = 22
#     }
#   }
# }
