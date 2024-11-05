variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "region" {
  type = string
}

variable "enabled" {
  type = bool
}

variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID"
}

variable "vault" {
  type = object({
    name = string
  })
}
