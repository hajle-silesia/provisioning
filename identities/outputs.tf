output "workload_identity_pool_name" {
  value = google_iam_workload_identity_pool.ext_secrets.name
}

output "workload_identity_pool_provider_name" {
  value = google_iam_workload_identity_pool_provider.ext_secrets.name
}
