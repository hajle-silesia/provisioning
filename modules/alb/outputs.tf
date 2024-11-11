output "internal_backend_set_name" {
  value       = oci_load_balancer_backend_set.default[0].name
  description = "The name of the internal backend set"
}

output "internal_lb_id" {
  value       = oci_load_balancer_load_balancer.default[0].id
  description = "The ID of the internal LB"
}

output "internal_lb_ip_address" {
  value       = oci_load_balancer_load_balancer.default[0].ip_address_details[0].ip_address
  description = "The IP address of the internal LB"
}
