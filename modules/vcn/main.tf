locals {
  enabled = data.context_config.main.enabled

  compartment_ocid              = var.compartment_ocid
  ipv4_cidr_blocks              = var.ipv4_cidr_blocks
  dns_label                     = var.dns_label
  default_route_table_no_routes = local.enabled && var.default_route_table_no_routes
  internet_gateway_enabled      = local.enabled && var.internet_gateway_enabled
}

data "context_config" "main" {}

data "context_label" "main" {}

data "context_tags" "main" {}

resource "oci_core_vcn" "default" {
  count = local.enabled ? 1 : 0

  compartment_id = local.compartment_ocid
  cidr_blocks    = local.ipv4_cidr_blocks
  display_name   = data.context_label.main.rendered
  dns_label      = local.dns_label
  freeform_tags  = data.context_tags.main.tags
}

resource "oci_core_default_route_table" "default" {
  count = local.default_route_table_no_routes ? 1 : 0

  compartment_id             = local.compartment_ocid
  manage_default_resource_id = oci_core_vcn.default[0].default_route_table_id

  # TODO: move route rules to appropriate module once created
  route_rules {
    network_entity_id = oci_core_internet_gateway.default[0].id
    destination       = "0.0.0.0/0"
  }
  freeform_tags = data.context_tags.main.tags
}

resource "oci_core_internet_gateway" "default" {
  count = local.internet_gateway_enabled ? 1 : 0

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default[0].id
  freeform_tags  = data.context_tags.main.tags
}
