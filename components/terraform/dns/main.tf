module "dns" {
  source = "../../../modules/dns"

  compartment_ocid   = var.compartment_ocid
  name               = var.lb.name
  vcn_id             = module.vcn_reference.outputs.vcn_id
  subnet_domain_name = module.vcn_reference.outputs.subnet_domain_name
  ip_address         = module.lb_reference.outputs.ip_address
}
