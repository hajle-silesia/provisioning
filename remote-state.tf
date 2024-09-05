module "vcn_reference" {
  #checkov:skip=CKV_TF_1:Cloud Posse module
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.6.0"

  component = "vcn"

  namespace   = "hs"
  tenant      = "plat"
  stage       = "prod"
  environment = "fra"
}
