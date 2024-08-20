output "vcn_id" {
  value       = module.vcn.id
  description = "The ID of the VCN"
}

output "subnet_id" {
  value       = module.subnets.id
  description = "The ID of the subnet"
}
