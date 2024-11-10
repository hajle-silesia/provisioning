module "nlb" {
  source = "../../../modules/nlb"

  compartment_ocid  = var.compartment_ocid
  name              = var.nlb.name
  subnet_id         = module.vcn_reference.outputs.subnet_id
  listener_port     = var.nlb.listener_port
  health_check_port = var.nlb.health_check_port
}
