module "vcn_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "vcn"

  namespace   = "hs"
  tenant      = "plat"
  stage       = "prod"
  environment = "fra"
}

module "alb_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "alb"

  namespace   = "hs"
  tenant      = "plat"
  stage       = "prod"
  environment = "fra"
}
