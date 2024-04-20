variable "compartment_ocid" {
  type = string
}

variable "name" {
  type = string
}

variable "network_id" {
  type = string
}

variable "region" {
  type = string
}

variable "availability_domains" {
  type = list(string)
}

variable "cidr_range" {
  type = string
}

variable "shape" {
  type = string
}

variable "image_id" {
  type = string
}

variable "nsg_id" {
  type = string
}
