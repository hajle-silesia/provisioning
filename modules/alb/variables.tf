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

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet"
}
variable "listener_port" {
  type        = number
  description = "The port for the listener"
}

variable "health_check_port" {
  type        = number
  description = "The port to send the health check request to"
}
