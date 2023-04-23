resource "google_compute_firewall" "api_server_firewall" {
  name    = "api-server-firewall"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [6443]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["server"]
}

resource "google_compute_firewall" "iap_server_firewall" {
  name    = "iap-server-firewall"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["server"]
}
