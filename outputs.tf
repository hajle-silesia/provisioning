output "external_lb_ip" {
  value = module.servers["us-central1"].external_lb_ip
}

output "internal_lb_ip" {
  value = module.servers["us-central1"].internal_lb_ip
}

output "first_server_internal_ip" {
  value = module.servers["us-central1"].first_server_internal_ip
}

output "key_value_store_ip" {
  value = module.key_value_store.key_value_store_ip
}

output "key_value_store_name" {
  value = module.key_value_store.key_value_store_name
}

output "key_value_store_user" {
  value = module.key_value_store.key_value_store_user
}

output "key_value_store_password" {
  value     = module.key_value_store.key_value_store_password
  sensitive = true
}

output "workload_identity_pool_provider_name" {
  value = module.identities.workload_identity_pool_provider_name
}

output "sa_external_secrets" {
  value = google_service_account.external_secrets.email
}
