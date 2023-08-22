variable "project" {
  type = string
}

variable "k3s_version" {
  type = string
}

variable "servers" {
  type = map
}

variable "agents" {
  type = map
}
