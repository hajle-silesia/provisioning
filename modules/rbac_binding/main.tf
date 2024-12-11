locals {
  namespaces = toset(var.namespaces)
  bindings = {
    for role, identities in var.bindings : role => [
      for identity in identities : {
        kind = element(split(":", identity), 0)
        name = element(split(":", identity), 1)
      }
    ]
  }
}

resource "kubernetes_namespace" "default" {
  for_each = local.namespaces

  metadata {
    name = each.key
  }
}

resource "kubernetes_role" "cluster_admin" {
  for_each = kubernetes_namespace.default

  metadata {
    name      = "cluster-admin"
    namespace = each.key
  }
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

# resource "kubernetes_role" "cluster_viewer" {
#   for_each = kubernetes_namespace.default
#
#   metadata {
#     name      = "cluster-viewer"
#     namespace = each.key
#   }
#   rule {
#     api_groups = []
#     resources = ["*"]
#     verbs = ["get", "list", "watch"]
#   }
# }

resource "kubernetes_role_binding_v1" "cluster_admin" {
  for_each = kubernetes_namespace.default

  metadata {
    name      = "cluster-admin"
    namespace = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cluster-admin"
  }
  dynamic "subject" {
    for_each = local.bindings["cluster-admin"]
    content {
      kind      = subject.value["kind"]
      name      = subject.value["name"]
      namespace = each.key
    }
  }
}

# resource "kubernetes_role_binding_v1" "cluster_viewer" {
#   for_each = kubernetes_namespace.default
#
#   metadata {
#     name      = "cluster-viewer"
#     namespace = each.key
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = "cluster-viewer"
#   }
#   dynamic "subject" {
#     for_each = local.bindings
#     content {
#       kind      = subject.value["kind"]
#       name      = subject.value["name"]
#       namespace = each.key
#     }
#   }
# }
