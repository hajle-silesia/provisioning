locals {
  namespaces = toset(var.namespaces)
  bindings = {
    for role, identities in var.bindings : role => [
      for identity in identities : {
        kind = split(":", identity)[0]
        name = split(":", identity)[1]
      }
    ]
  }
  roles = {
    cluster-admin = {
      api_groups = ["*"]
      resources  = ["*"]
      verbs      = ["*"]
    }
    cluster-viewer = {
      api_groups = ["*"]
      resources  = ["*"]
      verbs      = ["get", "list", "watch"]
    }
  }
  namespace_role_combinations = flatten([
    for namespace in local.namespaces : [
      for name, config in local.roles : {
        namespace = namespace
        name      = name
        config    = config
      }
    ]
  ])
}

output "namespace_role_combinations" {
  value = local.namespace_role_combinations
}

resource "kubernetes_namespace" "default" {
  for_each = local.namespaces

  metadata {
    name = each.value
  }
}

resource "kubernetes_role_v1" "default" {
  count = length(local.namespace_role_combinations)

  metadata {
    name      = local.namespace_role_combinations[count.index].name
    namespace = local.namespace_role_combinations[count.index].namespace
  }
  rule {
    api_groups = local.namespace_role_combinations[count.index].config.api_groups
    resources  = local.namespace_role_combinations[count.index].config.resources
    verbs      = local.namespace_role_combinations[count.index].config.verbs
  }
}

resource "kubernetes_role_binding_v1" "default" {
  count = length(local.namespace_role_combinations)

  metadata {
    name      = local.namespace_role_combinations[count.index].name
    namespace = local.namespace_role_combinations[count.index].namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = local.namespace_role_combinations[count.index].name
  }
  dynamic "subject" {
    for_each = local.bindings[local.namespace_role_combinations[count.index].name]
    content {
      kind      = subject.value["kind"]
      name      = subject.value["name"]
      namespace = local.namespace_role_combinations[count.index].namespace
    }
  }
}
