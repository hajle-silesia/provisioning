resource "google_compute_health_check" "internal" {
  name = "internal"

  timeout_sec = 1

  tcp_health_check {
    port = 6443
  }
}

resource "google_compute_health_check" "external" {
  name = "external"

  timeout_sec = 1

  tcp_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "external" {
  name                  = "external"
  load_balancing_scheme = "EXTERNAL"

  health_checks = [
    google_compute_health_check.external.id,
  ]
  port_name = "http"
  backend {
    group                 = google_compute_region_instance_group_manager.servers.instance_group
    balancing_mode        = "RATE"
    max_rate_per_instance = 20
  }
}

resource "google_compute_url_map" "external" {
  name            = "external"
  default_service = google_compute_backend_service.external.id
}

resource "google_compute_target_https_proxy" "external" {
  name             = "external"
  url_map          = google_compute_url_map.external.id
  ssl_certificates = [google_compute_ssl_certificate.default.id]
}

resource "google_compute_global_forwarding_rule" "external" {
  name                  = "external"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443-443"
  target                = google_compute_target_https_proxy.external.id
  ip_address            = google_compute_global_address.server_external.id
}

resource "google_compute_backend_service" "internal" {
  name                  = "internal"
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"

  health_checks = [
    google_compute_health_check.internal.id,
  ]
  backend {
    group                 = google_compute_region_instance_group_manager.servers.instance_group
    balancing_mode        = "RATE"
    max_rate_per_instance = 20
  }
}

resource "google_compute_url_map" "internal" {
  name            = "internal"
  default_service = google_compute_backend_service.internal.id
}

resource "google_compute_target_http_proxy" "internal" {
  name    = "internal"
  url_map = google_compute_url_map.internal.id
}

resource "google_compute_global_forwarding_rule" "internal" {
  name                  = "internal"
  network               = var.network
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
  port_range            = "6443-6443"
  target                = google_compute_target_http_proxy.internal.id
  ip_address            = google_compute_address.server_internal.id
}

resource "google_compute_ssl_certificate" "default" {
  name        = "default"
  private_key = file("./certificates/key.pem")
  certificate = file("./certificates/cert.pem")
}
