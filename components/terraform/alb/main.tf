resource "oci_load_balancer_backend_set" "internal" {
  name             = "internal"
  load_balancer_id = oci_load_balancer_load_balancer.internal.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = 6443
    protocol = "TCP"
  }
}

resource "oci_load_balancer_backend_set" "vault" {
  name             = "vault"
  load_balancer_id = oci_load_balancer_load_balancer.internal.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port        = 8200
    protocol    = "HTTP"
    return_code = 200
    url_path    = "/sys/health"
  }
}

resource "oci_load_balancer_listener" "internal" {
  name                     = "internal"
  load_balancer_id         = oci_load_balancer_load_balancer.internal.id
  default_backend_set_name = oci_load_balancer_backend_set.internal.name
  port                     = 6443
  protocol                 = "TCP"
}

resource "oci_load_balancer_listener" "vault" {
  name                     = "vault"
  load_balancer_id         = oci_load_balancer_load_balancer.internal.id
  default_backend_set_name = oci_load_balancer_backend_set.vault.name
  port                     = 8200
  protocol                 = "TCP"
}

resource "oci_load_balancer_load_balancer" "internal" {
  compartment_id = var.compartment_ocid
  display_name   = "internal"
  shape          = "flexible"
  subnet_ids = [
    module.vcn_reference.outputs.subnet_id,
  ]

  ip_mode    = "IPV4"
  is_private = true

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

resource "oci_load_balancer_certificate" "vault" {
  certificate_name = "vault"
  load_balancer_id = oci_load_balancer_load_balancer.internal.id

  ca_certificate     = var.vault_ca_cert
  private_key        = file("${path.module}/certificates/vault-key.pem")
  public_certificate = var.vault_cert

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_dns_view" "internal" {
  compartment_id = var.compartment_ocid
  scope          = "PRIVATE"
}

resource "oci_dns_zone" "internal" {
  compartment_id = var.compartment_ocid
  name           = local.name
  scope          = "PRIVATE"
  view_id        = oci_dns_view.internal.id
  zone_type      = "PRIMARY"
}

resource "oci_dns_rrset" "internal_lb" {
  domain          = local.name
  rtype           = "A"
  view_id         = oci_dns_view.internal.id
  scope           = "PRIVATE"
  zone_name_or_id = oci_dns_zone.internal.id
  items {
    domain = local.name
    rdata  = oci_load_balancer_load_balancer.internal.ip_address_details[0].ip_address
    rtype  = "A"
    ttl    = 300
  }
}

data "oci_core_vcn_dns_resolver_association" "default" {
  vcn_id = module.vcn_reference.outputs.vcn_id
}

resource "oci_dns_resolver" "default" {
  resolver_id = data.oci_core_vcn_dns_resolver_association.default.dns_resolver_id

  scope = "PRIVATE"
  attached_views {
    view_id = oci_dns_view.internal.id
  }
}
