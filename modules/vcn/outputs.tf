output "id" {
  value       = join("", oci_core_vcn.default[*].id)
  description = "The ID of the VCN"
}

output "igw_id" {
  value       = join("", oci_core_internet_gateway.default[*].id)
  description = "The ID of the internet gateway"
}

output "default_security_list_id" {
  value       = join("", oci_core_vcn.default[*].default_security_list_id)
  description = "The ID of the security list created by default on VCN creation"
}
