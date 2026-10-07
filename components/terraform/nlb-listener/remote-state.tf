module "nlb_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "2.0.1"

  component = "nlb"

  tenant      = var.tenant
  environment = var.environment
  stage       = var.stage
}
