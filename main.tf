module "vcn" {
  source                        = "./modules/vcn"
  compartment_ocid              = var.compartment_ocid
  ipv4_cidr_blocks              = var.vcn.ipv4_cidr_blocks
  dns_label                     = var.vcn.dns_label
  default_route_table_no_routes = var.vcn.default_route_table_no_routes
  internet_gateway_enabled      = var.vcn.internet_gateway_enabled
}

module "servers" {
  source   = "./nodes/servers"
  for_each = var.servers

  compartment_ocid       = var.compartment_ocid
  name                   = each.key
  network_id             = module.vcn.id
  availability_domains   = each.value.availability_domains
  cidr_range             = each.value.cidr_range
  shape                  = var.shape
  vault_cert_private_key = var.vault_cert_private_key
}

moved {
  from = module.firewall.oci_core_default_security_list.internal
  to   = module.vcn.oci_core_default_security_list.internal
}
