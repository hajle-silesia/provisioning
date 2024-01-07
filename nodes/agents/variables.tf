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

variable "k3s_version" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "target_size" {
  type = string
}

variable "internal_lb_ip" {
}

variable "token" {
}

variable "service_account" {
  type = string
}
