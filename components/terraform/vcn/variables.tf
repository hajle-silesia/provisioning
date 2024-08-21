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

variable "context" {
  type = object({
    enabled     = bool
    namespace   = string
    stage       = string
    environment = string
    name        = string
  })
}

variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID"
}

variable "vcn" {
  type = object({
    name                           = string
    ipv4_cidr_blocks               = list(string)
    dns_label                      = string
    default_security_list_deny_all = bool
    default_route_table_no_routes  = bool
    internet_gateway_enabled       = bool
  })
}

variable "subnets" {
  type = object({
    name                = string
    ipv4_cidr_block     = string
    dns_label           = string
    create_route_table  = bool
    route_table_enabled = bool
  })
}
