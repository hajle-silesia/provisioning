variable "config_path" {
  type = string
}

variable "namespaces" {
  type = list(string)
}

variable "bindings" {
  type = map(list(string))
}
