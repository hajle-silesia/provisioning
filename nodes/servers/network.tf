resource "google_compute_subnetwork" "servers" {
  name          = "servers-${var.name}"
  network       = var.network
  region        = var.region
  ip_cidr_range = var.cidr_range

  private_ip_google_access = true
}

resource "google_compute_router" "servers" {
  name    = "servers-${var.name}"
  network = var.network
  region  = var.region
}

resource "google_compute_router_nat" "servers" {
  name                               = "servers-${var.name}"
  region                             = var.region
  router                             = google_compute_router.servers.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.servers.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_address" "server_internal" {
  name         = "server-internal"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  region       = var.region
  subnetwork   = google_compute_subnetwork.servers.id
}

resource "google_compute_global_address" "server_external" {
  name   = "server-external"
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
