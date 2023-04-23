output "server_ip" {
  value = module.servers.server_ip
}

output "kubeconfig" {
  value     = data.external.kubeconfig.result.kubeconfig
  sensitive = true
}
