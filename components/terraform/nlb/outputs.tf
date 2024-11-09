output "nlb_backend_set_name" {
  value       = module.nlb.nlb_backend_set_name
  description = "The name of the backend set"
}

output "nlb_id" {
  value       = module.nlb.nlb_id
  description = "The ID of the NLB"
}
