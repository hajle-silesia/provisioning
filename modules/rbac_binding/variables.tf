variable "namespaces" {
  type        = list(string)
  description = "Namespaces"
}

variable "bindings" {
  type        = map(list(string))
  description = "Bindings"
}
