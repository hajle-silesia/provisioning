module "spaces" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component   = var.spacelift_spaces_component_name
  environment = try(var.spacelift_spaces_environment_name, module.this.environment)
  stage       = "spacelift"
  tenant      = try(var.spacelift_spaces_tenant_name, module.this.tenant)

  context = module.this.context
}
