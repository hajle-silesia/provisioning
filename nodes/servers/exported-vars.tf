data "template_file" "imported_vars" {
  template = <<-EOT
    # This file is generated automatically

    variable "internal_lb" {
      type    = string
      default = "$${INTERNAL_LB}"
    }

    EOT

  vars = {
    INTERNAL_LB = oci_load_balancer_load_balancer.internal.ip_address_details[0].ip_address
  }
}

resource "local_file" "imported_vars" {
  content  = data.template_file.imported_vars.rendered
  filename = "./machine-images/imported-vars.pkr.hcl"
}
