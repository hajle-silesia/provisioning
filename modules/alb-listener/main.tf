locals {
  enabled = data.context_config.main.enabled

  name              = var.name
  load_balancer_id  = var.load_balancer_id
  listener_port     = var.listener_port
  health_check_port = var.health_check_port
}

data "context_config" "main" {}

data "context_label" "main" {
  values = {
    name = local.name
  }
}

resource "oci_load_balancer_backend_set" "default" {
  count = local.enabled ? 1 : 0

  name             = data.context_label.main.rendered
  load_balancer_id = local.load_balancer_id
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = local.health_check_port
    protocol = "TCP"
  }
}

resource "oci_load_balancer_listener" "default" {
  count = local.enabled ? 1 : 0

  name                     = data.context_label.main.rendered
  load_balancer_id         = local.load_balancer_id
  default_backend_set_name = oci_load_balancer_backend_set.default[0].name
  port                     = local.listener_port
  protocol                 = "TCP"
}
