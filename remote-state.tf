module "vcn_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.6.0"

  component = "vcn"

  namespace   = "hs"
  tenant      = "plat"
  stage       = "prod"
  environment = "fra"
}
