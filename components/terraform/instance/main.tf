module "instance" {
  source = "../../../modules/instance"

  compartment_ocid = var.compartment_ocid
  name             = var.instance.name
  subnet_id        = module.vcn_reference.outputs.subnet_id
  shape            = var.instance.shape
  public_key       = var.instance.public_key
  load_balancers = {
    external_cluster_api = {
      id               = module.alb_reference.outputs.id
      backend_set_name = module.alb_listener_ext_cluster_api_reference.outputs.backend_set_name
      backend_port     = module.alb_listener_ext_cluster_api_reference.outputs.backend_port
    }
    internal_cluster_api = {
      id               = module.nlb_reference.outputs.id
      backend_set_name = module.nlb_reference.outputs.backend_set_name
      backend_port     = module.nlb_reference.outputs.port
    }
    external_https = {
      id               = module.alb_reference.outputs.id
      backend_set_name = module.alb_listener_ext_https_reference.outputs.backend_set_name
      backend_port     = module.alb_listener_ext_https_reference.outputs.backend_port
    }
  }

  # user-data script vars/secrets
  vault_name              = module.vault_reference.outputs.name
  secret_name             = module.vault_reference.outputs.secret_name
  k3s_version             = var.instance.k3s_version
  k3s_token               = var.k3s_token
  internal_lb_domain_name = module.dns_nlb_reference.outputs.domain_name
  external_lb_domain_name = module.dns_alb_reference.outputs.domain_name
}
