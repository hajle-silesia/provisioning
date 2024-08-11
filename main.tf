module "vcn" {
  source                         = "./modules/vcn"
  compartment_ocid               = var.compartment_ocid
  name                           = var.vcn.name
  ipv4_cidr_blocks               = var.vcn.ipv4_cidr_blocks
  dns_label                      = var.vcn.dns_label
  default_security_list_deny_all = var.vcn.default_security_list_deny_all
  default_route_table_no_routes  = var.vcn.default_route_table_no_routes
  internet_gateway_enabled       = var.vcn.internet_gateway_enabled
}

module "subnets" {
  source           = "./modules/subnets"
  compartment_ocid = var.compartment_ocid
  name             = var.subnets["eu-frankfurt-1"].name
  vcn_id           = module.vcn.id
  igw_id           = module.vcn.igw_id
  ipv4_cidr_block  = var.subnets["eu-frankfurt-1"].ipv4_cidr_block
  dns_label        = var.subnets["eu-frankfurt-1"].dns_label
}

module "servers" {
  source   = "./nodes/servers"
  for_each = var.subnets

  compartment_ocid       = var.compartment_ocid
  network_id             = module.vcn.id
  shape                  = var.shape
  vault_cert_private_key = var.vault_cert_private_key
  subnet_id              = module.subnets.id
}
