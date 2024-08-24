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

variable "subnets" {
  type = map(object({
    name                = string
    ipv4_cidr_block     = string
    dns_label           = string
    route_table_enabled = bool
  }))
}

variable "shape" {
  type = string
}

variable "instance_public_key" {
  type = string
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
