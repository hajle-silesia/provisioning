locals {
  enabled = data.context_config.main.enabled

  compartment_ocid    = var.compartment_ocid
  name                = var.name
  vcn_id              = var.vcn_id
  igw_id              = var.igw_id
  ipv4_cidr_block     = var.ipv4_cidr_block
  dns_label           = var.dns_label
  route_table_enabled = local.enabled && var.route_table_enabled
}

data "context_config" "main" {}

data "context_label" "main" {
  values = {
    name = local.name
  }
}

data "context_tags" "main" {
  values = {
    name = local.name
  }
}

resource "oci_core_subnet" "default" {
  count = local.enabled ? 1 : 0

  compartment_id = local.compartment_ocid
  display_name   = data.context_label.main.rendered
  vcn_id         = local.vcn_id
  cidr_block     = local.ipv4_cidr_block
  dns_label      = local.dns_label
  freeform_tags  = data.context_tags.main.tags
}

resource "oci_core_route_table" "default" {
  count = local.route_table_enabled ? 1 : 0

  compartment_id = local.compartment_ocid
  display_name   = data.context_label.main.rendered
  vcn_id         = local.vcn_id

  route_rules {
    network_entity_id = local.igw_id
    destination       = "0.0.0.0/0"
  }
  freeform_tags = data.context_tags.main.tags
}
