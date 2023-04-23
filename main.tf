terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.62.1"
    }
  }
}

provider "google" {
  project     = "hajle-silesia-brewing-system"
  region      = "us-central1"
  zone        = "us-central1-a"
  credentials = file("~/.google_cloud/hajle-silesia-brewing-system.json")
}

module "network" {
  source = "./network"
}

module "firewall" {
  source  = "./firewall"
  network = module.network.name
}

module "servers" {
  source  = "./nodes/servers"
  network = module.network.name
}

module "agents" {
  source   = "./nodes/agents"
  for_each = var.agents

  name       = each.key
  network    = module.network.name
  cidr_range = each.value.cidr_range
  server_ip  = module.servers.server_ip
  token      = module.servers.token
}

resource "null_resource" "server_ssh_readiness" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.servers.server_ip
      user        = "mtweeman"
      private_key = file("~/.ssh/id_ed25519")
    }

    script = "${path.module}/is-server-startup-script-finished.sh"
  }
}

data "external" "kubeconfig" {
  program = ["${path.module}/get-server-kubeconfig.sh"]
  query   = {
    server_ip = module.servers.server_ip
  }

  depends_on = [null_resource.server_ssh_readiness]
}
