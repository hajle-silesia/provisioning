variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "private_key_path" {
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

variable "network_cidr_range" {
  type = string
}

variable "servers" {
  type = map(any)
}

variable "shape" {
  type = string
}

variable "vault_cert_private_key" {
  type = string
}
