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
}

variable "subnet_domain_name" {
  type        = string
  description = "The subnet's domain name, which consists of the subnet's DNS label, the VCN's DNS label, and the oraclevcn.com domain"
}

variable "ip_address" {
  type        = string
  description = "The IP address of the DNS record"
}
