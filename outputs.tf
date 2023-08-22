output "external_lb_ip" {
  value = module.servers["europe-west4"].external_lb_ip
}

#output "kubeconfig" {
#  value     = data.external.kubeconfig.result.kubeconfig
#  sensitive = true
#}
