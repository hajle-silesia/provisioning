output "internal_backend_set_name" {
  value       = oci_load_balancer_backend_set.internal.name
  description = "The name of the internal backend set"
}

output "vault_backend_set_name" {
  value       = oci_load_balancer_backend_set.vault.name
  description = "The name of the vault backend set"
}

output "internal_lb_id" {
  value       = oci_load_balancer_load_balancer.internal.id
  description = "The ID of the internal LB"
}
