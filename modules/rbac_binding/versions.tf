terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.34.0"
    }
    context = {
      source  = "cloudposse/context"
      version = ">= 0.4.0"
    }
  }
}
