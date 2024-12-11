module "rbac_binding" {
  source = "../../../modules/rbac_binding"

  namespaces = var.namespaces
  bindings   = var.bindings
}
