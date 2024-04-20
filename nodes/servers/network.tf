resource "oci_core_subnet" "servers" {
  compartment_id = var.compartment_ocid
  display_name   = "servers-${var.name}"
  vcn_id         = var.network_id
  cidr_block     = var.cidr_range
}