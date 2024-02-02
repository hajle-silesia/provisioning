resource "google_compute_instance_template" "agent" {
  name_prefix  = "agent-${var.name}-"
  machine_type = var.machine_type
  tags         = [
    "agent",
  ]
  labels = {
    env = "prod"
  }

  metadata = {
    block-project-ssh-keys = true
    enable-oslogin         = true
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  disk {
    source_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-arm64-v20230302"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
    disk_type    = "pd-standard"
  }

  network_interface {
    network    = var.network
    subnetwork = google_compute_subnetwork.agents.id
  }

  service_account {
    email  = var.service_account
    scopes = [
      "cloud-platform",
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "agents" {
  name = "agents"

  base_instance_name        = "agent"
  region                    = var.region
  distribution_policy_zones = var.zones

  version {
    instance_template = google_compute_instance_template.agent.id
  }

  target_size = var.target_size

  update_policy {
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = length(var.zones)
  }
}
