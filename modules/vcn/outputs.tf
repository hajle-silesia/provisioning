output "id" {
  value       = join("", oci_core_vcn.default[*].id)
  description = "The ID of the VCN"
}

output "default_security_list_id" {
  value       = join("", oci_core_vcn.default[*].default_security_list_id)
  description = "The ID of the security list created by default on VCN creation"
}
