resource "random_string" "token" {
  length  = 32
  special = false
}

data "template_file" "server_startup_script" {
  template = file("${path.module}/create-server.sh")
  vars     = {
    k3s_version              = var.k3s_version
    token                    = random_string.token.result
    internal_lb_ip           = google_compute_address.server_internal.address
    external_lb_ip           = google_compute_global_address.server_external.address
    key_value_store_ip       = var.key_value_store_ip
    key_value_store_user     = var.key_value_store_user
    key_value_store_password = var.key_value_store_password
    key_value_store_name     = var.key_value_store_name
  }
}

resource "google_compute_instance_template" "server" {
  name_prefix  = "server-${var.name}-"
  machine_type = var.machine_type
  tags         = [
    "server",
  ]

  metadata_startup_script = data.template_file.server_startup_script.rendered

  metadata = {
    block-project-ssh-keys = "TRUE"
    enable-oslogin         = "TRUE"
  }

  disk {
    source_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-arm64-v20230302"
    auto_delete  = true
    boot         = true
    disk_size_gb = 15
    disk_type    = "pd-balanced"
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

  update_policy {
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = length(var.zones)
  }
}
