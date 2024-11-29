module "alb" {
  source = "../../../modules/alb"

  compartment_ocid = var.compartment_ocid
  name             = var.alb.name
  subnet_id        = module.vcn_reference.outputs.subnet_id
}
