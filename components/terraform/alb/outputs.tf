output "internal_backend_set_name" {
  value       = module.alb.internal_backend_set_name
  description = "The name of the internal backend set"
}

output "internal_lb_id" {
  value       = module.alb.internal_lb_id
  description = "The ID of the internal LB"
}

output "internal_lb_ip_address" {
  value       = module.alb.internal_lb_ip_address
  description = "The IP address of the internal LB"
}
