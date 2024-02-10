output "internal_lb_ip" {
  value = google_compute_address.server_internal.address
}

output "external_lb_ip" {
  value = google_compute_global_address.server_external.address
}

output "first_server_internal_ip" {
  value = data.google_compute_instance.instance_data.0.network_interface.0.network_ip
}
