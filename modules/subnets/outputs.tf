output "id" {
  value       = join("", oci_core_subnet.default[*].id)
  description = "The ID of the subnet"
}
