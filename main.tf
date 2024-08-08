module "network" {
  source             = "./network"
  compartment_ocid   = var.compartment_ocid
  network_cidr_range = var.network_cidr_range
}

module "firewall" {
  source                           = "./firewall"
  compartment_ocid                 = var.compartment_ocid
  network_default_security_list_id = module.network.object.default_security_list_id
  network_cidr_range               = var.network_cidr_range
}

module "servers" {
  source   = "./nodes/servers"
  for_each = var.servers

  compartment_ocid       = var.compartment_ocid
  name                   = each.key
  network_id             = module.network.object.id
  availability_domains   = each.value.availability_domains
  cidr_range             = each.value.cidr_range
  shape                  = var.shape
  vault_cert_private_key = var.vault_cert_private_key
}
