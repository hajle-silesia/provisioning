resource "google_compute_subnetwork" "servers_subnetwork" {
  name          = "servers-subnetwork"
  network       = var.network
  ip_cidr_range = "10.20.0.0/24"
}
