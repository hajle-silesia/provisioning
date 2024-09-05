provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  private_key  = var.private_key
  fingerprint  = var.fingerprint
  region       = var.region
}

provider "context" {
  enabled   = var.context.enabled
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
    namespace   = var.context.namespace
    stage       = var.context.stage
    environment = var.context.environment
    name        = var.context.name
  }
}
