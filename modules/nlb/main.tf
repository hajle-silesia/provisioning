locals {
  enabled = data.context_config.main.enabled

  compartment_ocid  = var.compartment_ocid
  name              = var.name
  subnet_id         = var.subnet_id
  listener_port     = var.listener_port
  health_check_port = var.health_check_port
}

data "context_config" "main" {}

data "context_label" "main" {
  values = {
    name = local.name
  }
}

data "context_tags" "main" {
  values = {
    name = local.name
  }
}

resource "oci_network_load_balancer_network_load_balancer" "default" {
  count = local.enabled ? 1 : 0

  compartment_id = local.compartment_ocid
  display_name   = data.context_label.main.rendered
  subnet_id      = local.subnet_id
  freeform_tags  = data.context_tags.main.tags
}

resource "oci_network_load_balancer_listener" "default" {
  count = local.enabled ? 1 : 0

  default_backend_set_name = oci_network_load_balancer_backend_set.default[0].name
  name                     = data.context_label.main.rendered
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.default[0].id
  port                     = local.listener_port
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "default" {
  count = local.enabled ? 1 : 0

  health_checker {
    protocol = "TCP"
    port     = local.health_check_port
  }

  name                     = data.context_label.main.rendered
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.default[0].id
  policy                   = "FIVE_TUPLE"
}
