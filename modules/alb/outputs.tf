output "id" {
  value       = join("", oci_load_balancer_load_balancer.default[*].id)
  description = "The ID of the ALB"
}

output "ip_address" {
  value       = join("", flatten(oci_load_balancer_load_balancer.default[*].ip_address_details[*].ip_address))
  description = "The IP address of the ALB"
}

output "certificate_name" {
  value       = join("", oci_load_balancer_certificate.default[*].certificate_name)
  description = "The name of the certificate"
}
