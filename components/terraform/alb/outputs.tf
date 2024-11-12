output "backend_set_name" {
  value       = module.alb.backend_set_name
  description = "The name of the backend set"
}

output "id" {
  value       = module.alb.id
  description = "The ID of the ALB"
}

output "ip_address" {
  value       = module.alb.ip_address
  description = "The IP address of the ALB"
}
