variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID"
  default     = null
}

variable "ipv4_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks for the VCN"
  default     = null
}

variable "default_route_table_no_routes" {
  type        = bool
  default     = false
  description = <<-EOT
    When `true`, manage the default route table and remove all routes, disabling all ingress and egress.
    When `false`, do not mange the default route table, allowing it to be managed by another component.
    EOT
}

variable "internet_gateway_enabled" {
  type        = bool
  description = "Set `true` to create an internet gateway for the VCN"
  default     = true
}

variable "dns_label" {
  type        = string
  description = <<-EOT
    DNS label for the VCN, used to form FQDN.
    Example of FQDN consisting of:
    - VNIC's hostname `instance1`
    - subnet's DNS label `subnet-1`
    - VCN's DNS label `vcn-2`
    would be `instance1.subnet-1.vcn-2.oraclevcn.com`
    EOT
  default     = null
}
