resource "google_iam_workload_identity_pool" "ext_secrets" {
  workload_identity_pool_id = "ext-secrets19"
}

resource "google_iam_workload_identity_pool_provider" "ext_secrets" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.ext_secrets.workload_identity_pool_id
  workload_identity_pool_provider_id = google_iam_workload_identity_pool.ext_secrets.workload_identity_pool_id
  display_name                       = "external-secrets"

  oidc {
    issuer_uri        = "https://hajlesilesia.online"
    allowed_audiences = [
      "sts.googleapis.com",
    ]
  }

  attribute_mapping = {
    "google.subject"                 = "assertion.sub"
    "attribute.kubernetes_namespace" = "assertion[\"kubernetes.io\"][\"namespace\"]"
  }

  attribute_condition = "attribute.kubernetes_namespace==\"external-secrets\""
}
