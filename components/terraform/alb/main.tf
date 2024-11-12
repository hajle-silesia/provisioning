module "alb" {
  source = "../../../modules/alb"

  compartment_ocid  = var.compartment_ocid
  name              = var.alb.name
  subnet_id         = module.vcn_reference.outputs.subnet_id
  listener_port     = var.alb.listener_port
  health_check_port = var.alb.health_check_port
}
