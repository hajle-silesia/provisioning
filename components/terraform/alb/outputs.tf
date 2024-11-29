output "id" {
  value       = module.alb.id
  description = "The ID of the ALB"
}

output "ip_address" {
  value       = module.alb.ip_address
  description = "The IP address of the ALB"
}
