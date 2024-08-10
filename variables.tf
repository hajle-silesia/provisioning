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

variable "context" {
  type = object({
    enabled     = bool
    namespace   = string
    stage       = string
    environment = string
    name        = string
  })
}

variable "vcn" {
  type = object({
    ipv4_cidr_blocks              = list(string)
    default_route_table_no_routes = bool
    internet_gateway_enabled      = bool
    dns_label                     = string
  })
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
