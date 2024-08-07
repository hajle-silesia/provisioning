resource "oci_core_vcn" "default" {
  compartment_id = var.compartment_ocid
  cidr_blocks = [
    var.network_cidr_range,
  ]
  display_name = "default"
  dns_label    = "default"
}

resource "oci_core_internet_gateway" "default" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id
}

resource "oci_core_default_route_table" "default" {
  manage_default_resource_id = oci_core_vcn.default.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.default.id
    destination       = "0.0.0.0/0"
  }
}
