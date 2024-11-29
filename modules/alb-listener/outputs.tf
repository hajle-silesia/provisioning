output "backend_set_name" {
  value       = join("", oci_load_balancer_backend_set.default[*].name)
  description = "The name of the backend set"
}
