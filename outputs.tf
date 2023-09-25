output "external_lb_ip" {
  value = module.servers["us-central1"].external_lb_ip
}

#output "kubeconfig" {
#  value     = data.external.kubeconfig.result.kubeconfig
#  sensitive = true
#}
