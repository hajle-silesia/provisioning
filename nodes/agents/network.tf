resource "google_compute_subnetwork" "agents" {
  name          = "agents-${var.name}"
  network       = var.network
  region        = var.region
  ip_cidr_range = var.cidr_range

  private_ip_google_access = true
}

resource "google_compute_router" "agents" {
  name    = "agents-${var.name}"
  network = var.network
  region  = var.region
}

resource "google_compute_router_nat" "agents" {
  name                               = "agents-${var.name}"
  region                             = var.region
  router                             = google_compute_router.agents.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.agents.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
