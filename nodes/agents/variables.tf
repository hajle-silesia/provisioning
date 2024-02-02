variable "name" {
  type = string
}

variable "network" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "cidr_range" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "target_size" {
  type = string
}

variable "service_account" {
  type = string
}
