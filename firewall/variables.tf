variable "compartment_ocid" {
  type = string
}

variable "network_default_security_list_id" {
  type = string
}

variable "network_cidr_ranges" {
  type = list(string)
}
