terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "network" {
  source             = "./network"
  compartment_ocid   = var.compartment_ocid
  network_cidr_range = var.network_cidr_range
}

module "servers" {
  source   = "./nodes/servers"
  for_each = var.servers

  compartment_ocid     = var.compartment_ocid
  name                 = each.key
  network_id           = module.network.id
  region               = each.value.region
  availability_domains = each.value.availability_domains
  cidr_range           = each.value.cidr_range
  shape                = each.value.shape
  image_id             = each.value.image_id
  nsg_id               = module.firewall.nsg_id
}

module "firewall" {
  source           = "./firewall"
  compartment_ocid = var.compartment_ocid
  network_id       = module.network.id
}
