module "servers" {
  source   = "./nodes/servers"
  for_each = var.subnets

  compartment_ocid       = var.compartment_ocid
  network_id             = module.vcn_reference.outputs.vcn_id
  shape                  = var.shape
  vault_cert_private_key = var.vault_cert_private_key
  subnet_id              = module.vcn_reference.outputs.subnet_id
  instance_public_key    = var.instance_public_key
  vault_ca_cert          = var.vault_ca_cert
  vault_cert             = var.vault_cert
}
