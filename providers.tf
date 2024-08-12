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
    environment = {
      required = true
    }
    stage = {
      required         = true
      validation_regex = "^(dev|test|prod)"
    }
    name = {
      required = true
    }
  }
  tags_key_case = "title"
  values = {
    namespace   = var.context.namespace
    environment = var.context.environment
    stage       = var.context.stage
    name        = var.context.name
  }
}
