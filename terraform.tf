terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 6.0"
    }
    context = {
      source  = "cloudposse/context"
      version = "~> 0.4"
    }
  }
}
