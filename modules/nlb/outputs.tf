output "id" {
  value       = join("", oci_network_load_balancer_network_load_balancer.default[*].id)
  description = "The ID of the NLB"
}

output "ip_address" {
  value       = join("", flatten(oci_network_load_balancer_network_load_balancer.default[*].ip_addresses[*].ip_address))
  description = "The IP address of the NLB"
}

output "backend_set_name" {
  value       = join("", oci_network_load_balancer_backend_set.default[*].name)
  description = "The name of the backend set"
}

output "port" {
  value       = join("", oci_network_load_balancer_listener.default[*].port)
  description = "The port of the listener"
}
