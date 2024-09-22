variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "private_key" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "region" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "context" {
  type = object({
    enabled     = bool
    namespace   = string
    stage       = string
    environment = string
    name        = string
  })
}

variable "vault_cert_private_key" {
  type = string
}

variable "vault_ca_cert" {
  type = string
}

variable "vault_cert" {
  type = string
}
