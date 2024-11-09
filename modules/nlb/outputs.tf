output "nlb_backend_set_name" {
  value       = join("", oci_network_load_balancer_backend_set.default[*].name)
  description = "The name of the backend set"
}

output "nlb_id" {
  value       = join("", oci_network_load_balancer_network_load_balancer.default[*].id)
  description = "The ID of the NLB"
}
