resource "google_compute_instance_template" "server" {
  name_prefix  = "server-${var.name}-"
  machine_type = var.machine_type
  tags         = [
    "server",
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
    subnetwork = google_compute_subnetwork.servers.id
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

resource "google_compute_region_instance_group_manager" "servers" {
  name = "servers"

  base_instance_name        = "server"
  region                    = var.region
  distribution_policy_zones = var.zones

  version {
    instance_template = google_compute_instance_template.server.id
  }

  target_size = var.target_size

  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "cluster-api"
    port = 6443
  }

  update_policy {
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = length(var.zones)
  }
}

data "google_compute_region_instance_group" "mig_data" {
  self_link = google_compute_region_instance_group_manager.servers.self_link
}

data "google_compute_instance" "instance_data" {
  self_link = data.google_compute_region_instance_group.mig_data.instances[count.index].instance
  count     = length(data.google_compute_region_instance_group.mig_data.instances)
}
