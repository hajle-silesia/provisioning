variable "compartment_ocid" {
  type = string
}

variable "name" {
  type = string
}

variable "network_id" {
  type = string
}

variable "cidr_range" {
  type = string
}

variable "availability_domains" {
  type = list(string)
}

variable "shape" {
  type = string
}
