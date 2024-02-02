output "internal_lb_ip" {
  value = google_compute_address.server_internal.address
}

output "external_lb_ip" {
  value = google_compute_global_address.server_external.address
}
