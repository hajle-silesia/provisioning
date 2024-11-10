module "alb" {
  source = "../../../modules/alb"

  compartment_ocid = var.compartment_ocid
  name             = var.alb.name
  vcn_id           = module.vcn_reference.outputs.vcn_id
  subnet_id        = module.vcn_reference.outputs.subnet_id
}
