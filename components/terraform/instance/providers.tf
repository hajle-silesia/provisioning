provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}

provider "context" {
  enabled   = var.enabled
  delimiter = "-"
  property_order = [
    "namespace",
    "stage",
    "environment",
    "name",
  ]
  properties = {
    namespace = {
      required   = true
      max_length = 3
    }
    stage = {
      required         = true
      validation_regex = "^(dev|test|prod)"
    }
    environment = {
      required = true
    }
    name = {
      required = true
    }
  }
  tags_key_case = "title"
  values = {
    namespace   = var.namespace
    stage       = var.stage
    environment = var.environment
    name        = var.name
  }
}
