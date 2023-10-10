terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.62.1"
    }
  }
}

provider "google" {
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_service_account" "servers" {
  account_id   = "servers"
  display_name = "servers"
}

resource "google_service_account" "agents" {
  account_id   = "agents"
  display_name = "agents"
}

resource "google_project_iam_binding" "servers" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/osconfig.guestPolicyAdmin",
  ])

  project = var.project
  role    = each.value
  members = [
    "serviceAccount:${google_service_account.servers.email}",
    "serviceAccount:${google_service_account.agents.email}",
  ]
}

resource "google_service_account" "external_secrets" {
  account_id   = "external-secrets"
  display_name = "external-secrets"
}

resource "google_secret_manager_secret_iam_binding" "external_secrets" {
  for_each = toset([
    "file-content",
  ])

  project   = var.project
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  members   = [
    google_service_account.external_secrets.member
  ]
}

resource "google_service_account_iam_member" "main" {
  service_account_id = google_service_account.external_secrets.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${module.identities.workload_identity_pool_name}/*"
}

module "services" {
  source = "./services"
}

module "network" {
  source = "./network"
}

module "firewall" {
  source  = "./firewall"
  network = module.network.id
}

module "key_value_store" {
  source = "./key-value-store"

  network = module.network.id
}

module "servers" {
  source   = "./nodes/servers"
  for_each = var.servers

  name            = each.key
  network         = module.network.id
  region          = each.value.region
  zones           = each.value.zones
  cidr_range      = each.value.cidr_range
  k3s_version     = var.k3s_version
  machine_type    = each.value.machine_type
  target_size     = each.value.target_size
  service_account = google_service_account.servers.email

  key_value_store_ip       = module.key_value_store.key_value_store_ip
  key_value_store_name     = module.key_value_store.key_value_store_name
  key_value_store_user     = module.key_value_store.key_value_store_user
  key_value_store_password = module.key_value_store.key_value_store_password
}

module "agents" {
  source   = "./nodes/agents"
  for_each = var.agents

  name            = each.key
  network         = module.network.id
  region          = each.value.region
  zones           = each.value.zones
  cidr_range      = each.value.cidr_range
  k3s_version     = var.k3s_version
  machine_type    = each.value.machine_type
  target_size     = each.value.target_size
  server_ip       = module.servers["us-central1"].internal_lb_ip
  token           = module.servers["us-central1"].token
  service_account = google_service_account.agents.email
}

module "identities" {
  source = "./identities"
}

module "dns" {
  source = "./dns"

  external_lb_ip = module.servers["us-central1"].external_lb_ip
}

#resource "null_resource" "server_ssh_readiness" {
#  provisioner "remote-exec" {
#    connection {
#      type     = "ssh"
#      host     = module.servers.server_ip
#      user     = "root"
#      password = ""
#    }
#
#    scripts = [
#      "${path.module}/is-server-startup-script-finished.sh",
#    ]
#  }
#}
#
#resource "null_resource" "copying_secrets" {
#  provisioner "file" {
#    connection {
#      type     = "ssh"
#      host     = module.servers.server_ip
#      user     = "root"
#      password = ""
#    }
#
#    source      = "/home/the401/.google_cloud/file-content-secret.key"
#    destination = "/home/mtweeman/file-content-secret.key"
#  }
#
#  depends_on = [null_resource.server_ssh_readiness]
#}
#
#resource "null_resource" "argo_cd_deployment" {
#  provisioner "remote-exec" {
#    connection {
#      type     = "ssh"
#      host     = module.servers.server_ip
#      user     = "root"
#      password = ""
#    }
#
#    scripts = [
#      "${path.module}/deploy-argo-cd.sh",
#      "${path.module}/deploy-secrets.sh",
#      "${path.module}/deploy-app.sh",
#    ]
#  }
#
#  depends_on = [null_resource.copying_secrets]
#}
#
#data "external" "kubeconfig" {
#  program = ["${path.module}/get-server-kubeconfig.sh"]
#  query   = {
#    server_ip = module.servers.server_ip
#  }
#
#  depends_on = [null_resource.server_ssh_readiness]
#}
