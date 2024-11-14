output "name" {
  value       = module.vault.name
  description = "The name of the vault"
}

output "secret_name" {
  value       = module.vault.secret_name
  description = "The secret name"
}
