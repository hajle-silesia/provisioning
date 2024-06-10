resource "oci_load_balancer_backend_set" "internal" {
  name             = "internal"
  load_balancer_id = oci_load_balancer_load_balancer.internal.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = 6443
    protocol = "TCP"
  }
}

resource "oci_load_balancer_load_balancer" "internal" {
  compartment_id = var.compartment_ocid
  display_name   = "internal"
  shape          = "flexible"
  subnet_ids     = [
    oci_core_subnet.servers.id,
  ]

  ip_mode    = "IPV4"
  is_private = true

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

resource "oci_load_balancer_listener" "internal" {
  name                     = "internal"
  load_balancer_id         = oci_load_balancer_load_balancer.internal.id
  default_backend_set_name = oci_load_balancer_backend_set.internal.name
  port                     = 6443
  protocol                 = "TCP"
}
