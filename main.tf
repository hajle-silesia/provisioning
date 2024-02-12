terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.14.0"
    }
  }

  backend "gcs" {
    bucket = "brewing-system-state-prod"
    prefix = "terraform/state"
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

  network                  = module.network.id
  KEY_VALUE_STORE_PASSWORD = var.KEY_VALUE_STORE_PASSWORD
}

module "servers" {
  source   = "./nodes/servers"
  for_each = var.servers

  name            = each.key
  network         = module.network.id
  region          = each.value.region
  zones           = each.value.zones
  cidr_range      = each.value.cidr_range
  machine_type    = each.value.machine_type
  target_size     = each.value.target_size
  service_account = google_service_account.servers.email
}

module "agents" {
  source   = "./nodes/agents"
  for_each = var.agents

  name            = each.key
  network         = module.network.id
  region          = each.value.region
  zones           = each.value.zones
  cidr_range      = each.value.cidr_range
  machine_type    = each.value.machine_type
  target_size     = each.value.target_size
  service_account = google_service_account.agents.email
}

module "identities" {
  source = "./identities"
}

module "dns" {
  source = "./dns"

  external_lb_ip = module.servers["us-central1"].external_lb_ip
}

module "monitoring" {
  source = "./monitoring"
}
