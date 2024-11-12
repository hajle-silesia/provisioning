locals {
  enabled = data.context_config.main.enabled

  compartment_ocid   = var.compartment_ocid
  name               = var.name
  vcn_id             = var.vcn_id
  subnet_domain_name = var.subnet_domain_name
  ip_address         = var.ip_address
  domain             = "${data.context_label.any.rendered}.${local.subnet_domain_name}"
}

data "context_config" "main" {}

data "context_label" "main" {
  values = {
    name = local.name
  }
}

data "context_label" "any" {
  # The same golden image can be shared across stages, hence the stage "any" is included in the label, to keep the naming convention consistent.
  # Upon NLB creation, a DNS record using NLB display name is automatically created. However, this record is not updated when the display name changes.
  # Upon ALB creation, no DNS record is created.
  # Baking the DNS record created by this module into the golden image (e.g.: as a SAN of K3s cluster) requires that the DNS record can be resolved regardless of the stage.
  values = {
    stage = "any"
    name  = local.name
  }
}

data "context_tags" "main" {
  values = {
    name = local.name
  }
}

resource "oci_dns_view" "default" {
  count = local.enabled ? 1 : 0

  compartment_id = local.compartment_ocid
  display_name   = data.context_label.any.rendered
  scope          = "PRIVATE"
  freeform_tags  = data.context_tags.main.tags
}

resource "oci_dns_zone" "default" {
  count = local.enabled ? 1 : 0

  compartment_id = local.compartment_ocid
  name           = local.domain
  scope          = "PRIVATE"
  view_id        = oci_dns_view.default[0].id
  zone_type      = "PRIMARY"
  freeform_tags  = data.context_tags.main.tags
}

resource "oci_dns_rrset" "default" {
  count = local.enabled ? 1 : 0

  domain          = local.domain
  rtype           = "A"
  view_id         = oci_dns_view.default[0].id
  scope           = "PRIVATE"
  zone_name_or_id = oci_dns_zone.default[0].id
  items {
    domain = local.domain
    rdata  = local.ip_address
    rtype  = "A"
    ttl    = 300
  }
}

data "oci_core_vcn_dns_resolver_association" "default" {
  vcn_id = local.vcn_id
}

resource "oci_dns_resolver" "default" {
  resolver_id  = data.oci_core_vcn_dns_resolver_association.default.dns_resolver_id
  display_name = data.context_label.main.rendered
  scope        = "PRIVATE"
  attached_views {
    view_id = oci_dns_view.default[0].id
  }
  freeform_tags = data.context_tags.main.tags
}
