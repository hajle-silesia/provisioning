output "id" {
  value       = oci_core_vcn.default[0].id
  description = "The ID of the VCN"
}

output "igw_id" {
  value       = try(oci_core_internet_gateway.default[0].id, "")
  description = "The ID of the internet gateway"
}
