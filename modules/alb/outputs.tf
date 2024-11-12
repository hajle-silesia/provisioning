output "backend_set_name" {
  value       = join("", oci_load_balancer_backend_set.default[*].name)
  description = "The name of the backend set"
}

output "id" {
  value       = join("", oci_load_balancer_load_balancer.default[*].id)
  description = "The ID of the ALB"
}

output "ip_address" {
  value       = join("", flatten(oci_load_balancer_load_balancer.default[*].ip_address_details[*].ip_address))
  description = "The IP address of the ALB"
}
