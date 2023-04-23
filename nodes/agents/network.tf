resource "google_compute_subnetwork" "agents_subnetwork" {
  name          = "agents-subnetwork-${var.name}"
  network       = var.network
  ip_cidr_range = var.cidr_range
}
