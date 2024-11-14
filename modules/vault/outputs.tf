output "name" {
  value       = join("", oci_kms_vault.default[*].display_name)
  description = "The name of the vault"
}

output "secret_name" {
  value       = join("", oci_vault_secret.default[*].secret_name)
  description = "The secret name"
}
