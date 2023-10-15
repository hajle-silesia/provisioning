resource "google_compute_firewall" "iap" {
  name    = "iap"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [
      22,
    ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
  target_tags = [
    "server",
    "agent",
  ]
}

resource "google_compute_firewall" "internal" {
  name    = "internal"
  network = var.network

  allow {
    protocol = "all"
  }

  source_tags = [
    "server",
    "agent",
  ]
  target_tags = [
    "server",
    "agent",
  ]
}
