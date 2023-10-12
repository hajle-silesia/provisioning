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

resource "google_compute_region_backend_service" "internal" {
  name                  = "internal"
  region                = var.region
  load_balancing_scheme = "INTERNAL"

  health_checks = [
    google_compute_health_check.internal.id,
  ]
  backend {
    group = google_compute_region_instance_group_manager.servers.instance_group
  }
}

resource "google_compute_forwarding_rule" "internal" {
  name                  = "internal"
  subnetwork            = google_compute_subnetwork.servers.self_link
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  allow_global_access   = true
  ports                 = [
    6443,
  ]
  backend_service = google_compute_region_backend_service.internal.id
  ip_address      = google_compute_address.server_internal.id
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
    max_rate_per_instance = 200
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

resource "google_compute_ssl_certificate" "default" {
  name        = "default"
  private_key = file("./certificates/key.pem")
  certificate = file("./certificates/cert.pem")
}

resource "google_compute_url_map" "external_redirect" {
  name = "external-redirect"
  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
    https_redirect         = true
  }
}

resource "google_compute_target_http_proxy" "external_redirect" {
  name             = "external-redirect"
  url_map          = google_compute_url_map.external_redirect.id
}

resource "google_compute_global_forwarding_rule" "external_redirect" {
  name                  = "external-redirect"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80-80"
  target                = google_compute_target_http_proxy.external_redirect.id
  ip_address            = google_compute_global_address.server_external.id
}


