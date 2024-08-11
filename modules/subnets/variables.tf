variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID"
  default     = null
}

variable "name" {
  type        = string
  description = "The name used as a part of resources display name"
  default     = null
}

variable "vcn_id" {
  type        = string
  description = "The ID of the VCN"
  default     = null
}

variable "ipv4_cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
  default     = null
}

variable "dns_label" {
  type        = string
  description = <<-EOT
    DNS label for the subnet, used to form FQDN.
    Example of FQDN consisting of:
    - VNIC's hostname `instance1`
    - subnet's DNS label `subnet-1`
    - VCN's DNS label `vcn-2`
    would be `instance1.subnet-1.vcn-2.oraclevcn.com`
    EOT
  default     = null
}
