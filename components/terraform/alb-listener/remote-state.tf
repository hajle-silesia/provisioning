module "alb_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "2.0.0"

  component = "alb"

  tenant      = var.tenant
  environment = var.environment
  stage       = var.stage
}
