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

resource "google_compute_firewall" "http_hc" {
  name    = "http-hc"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [
      80,
    ]
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22",
  ]
  target_tags = [
    "server",
  ]
}

resource "google_compute_firewall" "internal_hc" {
  name    = "internal-hc"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [
      6443,
    ]
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22",
  ]
  target_tags = [
    "server",
  ]
}
