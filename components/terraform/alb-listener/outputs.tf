output "backend_set_name" {
  value       = module.alb_listener.backend_set_name
  description = "The name of the backend set"
}

output "port" {
  value       = module.alb_listener.port
  description = "The port of the listener"
}
