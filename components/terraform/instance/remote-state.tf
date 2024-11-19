module "vault_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "vault"

  tenant      = var.tenant
  environment = var.environment
  stage       = var.stage
}


module "vcn_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "vcn"

  tenant      = var.tenant
  environment = var.environment
  stage       = var.stage
}

module "alb_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "alb"

  tenant      = var.tenant
  environment = var.environment
  stage       = var.stage
}

module "nlb_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "nlb"

  tenant      = var.tenant
  environment = var.environment
  stage       = var.stage
}

module "dns_alb_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "dns/alb"

  tenant      = var.tenant
  environment = var.environment
  stage       = var.stage
}

module "dns_nlb_reference" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "dns/nlb"

  tenant      = var.tenant
  environment = var.environment
  stage       = var.stage
}