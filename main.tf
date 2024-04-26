terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 5.0"
    }
  }

  backend "http" {
    address       = "https://fru7nifnglug.objectstorage.eu-frankfurt-1.oci.customer-oci.com/p/nY37eHyOBRm3TsUEp4JBiLHGy4F3Tm3imROtqIe4tJyQBkW2wZEgOUDdLb04z0eG/n/fru7nifnglug/b/backend/o/state/terraform.tfstate"
    update_method = "PUT"
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}

module "network" {
  source             = "./network"
  compartment_ocid   = var.compartment_ocid
  network_cidr_range = var.network_cidr_range
}

module "firewall" {
  source                           = "./firewall"
  compartment_ocid                 = var.compartment_ocid
  network_id                       = module.network.object.id
  network_default_security_list_id = module.network.object.default_security_list_id
}

module "servers" {
  source   = "./nodes/servers"
  for_each = var.servers

  compartment_ocid     = var.compartment_ocid
  name                 = each.key
  network_id           = module.network.object.id
  availability_domains = each.value.availability_domains
  cidr_range           = each.value.cidr_range
  shape                = var.shape
  image_id             = var.image_id
  nsg_id               = module.firewall.nsg_id
}
