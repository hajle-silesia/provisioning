data "template_file" "agent-startup-script" {
  template = file("${path.module}/create-agent.sh")
  vars     = {
    token     = var.token
    server_ip = var.server_ip
  }
}

resource "google_compute_instance_template" "agent_template" {
  lifecycle {
    create_before_destroy = true
  }

  name_prefix  = "agent-${var.name}-"
  machine_type = "t2a-standard-1"
  tags         = ["agent"]

  metadata = {
    ssh-keys = file("~/.ssh/id_ed25519.pub")
  }

  disk {
    source_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-arm64-v20230302"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    disk_type    = "pd-balanced"
  }

  network_interface {
    network    = var.network
    subnetwork = google_compute_subnetwork.agents_subnetwork.id
    access_config {
    }
  }

  metadata_startup_script = data.template_file.agent-startup-script.rendered
}

resource "google_compute_instance_group_manager" "agents" {
  name = "agents-${var.name}"

  base_instance_name = "agent-${var.name}"

  version {
    instance_template = google_compute_instance_template.agent_template.id
  }

  target_size = 2
}