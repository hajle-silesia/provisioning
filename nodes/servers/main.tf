resource "random_string" "token" {
  length  = 32
  special = false
}

data "template_file" "server-startup-script" {
  template = file("${path.module}/create-server.sh")
  vars     = {
    token = random_string.token.result
  }
}

resource "google_compute_instance" "server" {
  name         = "server"
  machine_type = "t2a-standard-1"
  tags         = ["server"]

  metadata = {
    ssh-keys = file("~/.ssh/id_ed25519.pub")
  }

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-arm64-v20230302"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = google_compute_subnetwork.servers_subnetwork.id
    access_config {
    }
  }

  metadata_startup_script = data.template_file.server-startup-script.rendered
}
