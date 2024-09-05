variable "tenancy_ocid" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaablce6gcqz3rbcsp5sab27djnmzblcv4dtvvwtctl2toucgqcyeha"
}

variable "user_ocid" {
  type    = string
  default = "ocid1.user.oc1..aaaaaaaanb4hbpro6ncmqwomnv2yei5fuu3pnxrr5xuper766vov6lyt4bda"
}

variable "key_file" {
  type    = string
  default = "certificates/mtweeman@gmail.com_2024-03-02T19_23_13.049Z.pem"
}

variable "fingerprint" {
  type    = string
  default = "a3:1c:b7:cb:dd:a2:ac:b2:66:c8:b0:b6:c9:18:0b:bc"
}

variable "region" {
  type    = string
  default = "eu-frankfurt-1"
}

variable "k3s_version" {
  type    = string
  default = "v1.29.4+k3s1"
}

variable "k3s_token" {
  type = string
  default = env("K3S_TOKEN")
}

variable "availability_domain" {
  type    = string
  default = "ppDV:EU-FRANKFURT-1-AD-1"
}
