locals {
  enabled = data.context_config.main.enabled

  compartment_ocid  = var.compartment_ocid
  name              = var.name
  subnet_id         = var.subnet_id
  vcn_id            = var.vcn_id
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

resource "oci_load_balancer_load_balancer" "internal" {
  count = local.enabled ? 1 : 0

  compartment_id = local.compartment_ocid
  display_name   = data.context_label.main.rendered
  shape          = "flexible"
  subnet_ids = [
    local.subnet_id,
  ]

  ip_mode    = "IPV4"
  is_private = true

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
  freeform_tags = data.context_tags.main.tags
}

resource "oci_load_balancer_backend_set" "internal" {
  count = local.enabled ? 1 : 0

  name             = "internal"
  load_balancer_id = oci_load_balancer_load_balancer.internal[0].id
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = local.health_check_port
    protocol = "TCP"
  }
}

resource "oci_load_balancer_listener" "internal" {
  count = local.enabled ? 1 : 0

  name                     = "internal"
  load_balancer_id         = oci_load_balancer_load_balancer.internal[0].id
  default_backend_set_name = oci_load_balancer_backend_set.internal[0].name
  port                     = local.listener_port
  protocol                 = "TCP"
}

resource "oci_dns_view" "internal" {
  compartment_id = local.compartment_ocid
  scope          = "PRIVATE"
}

resource "oci_dns_zone" "internal" {
  compartment_id = local.compartment_ocid
  name           = "internal-lb.servers.default.oraclevcn.com"
  scope          = "PRIVATE"
  view_id        = oci_dns_view.internal.id
  zone_type      = "PRIMARY"
}

resource "oci_dns_rrset" "internal_lb" {
  domain          = "internal-lb.servers.default.oraclevcn.com"
  rtype           = "A"
  view_id         = oci_dns_view.internal.id
  scope           = "PRIVATE"
  zone_name_or_id = oci_dns_zone.internal.id
  items {
    domain = "internal-lb.servers.default.oraclevcn.com"
    rdata  = oci_load_balancer_load_balancer.internal[0].ip_address_details[0].ip_address
    rtype  = "A"
    ttl    = 300
  }
}

data "oci_core_vcn_dns_resolver_association" "default" {
  vcn_id = local.vcn_id
}

resource "oci_dns_resolver" "default" {
  resolver_id = data.oci_core_vcn_dns_resolver_association.default.dns_resolver_id

  scope = "PRIVATE"
  attached_views {
    view_id = oci_dns_view.internal.id
  }
  freeform_tags = data.context_tags.main.tags
}
