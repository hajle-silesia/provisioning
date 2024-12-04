output "id" {
  value       = module.nlb.id
  description = "The ID of the NLB"
}

output "ip_address" {
  value       = module.nlb.ip_address
  description = "The IP address of the NLB"
}

output "backend_set_name" {
  value       = module.nlb.backend_set_name
  description = "The name of the backend set"
}

output "port" {
  value       = module.nlb.port
  description = "The port of the listener"
}
