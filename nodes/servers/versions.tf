terraform {
  required_version = ">= 1.0.0"

  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 5.9.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
    context = {
      source  = "cloudposse/context"
      version = ">= 0.4.0"
    }
  }
}
