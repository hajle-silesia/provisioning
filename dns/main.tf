resource "google_dns_managed_zone" "default" {
  name          = "hajlesilesia-online"
  dns_name      = "hajlesilesia.online."
  description   = "hajlesilesia Public DNS zone"
  force_destroy = "true"
}

resource "google_dns_record_set" "default" {
  name         = google_dns_managed_zone.default.dns_name
  managed_zone = google_dns_managed_zone.default.name
  type         = "A"
  ttl          = 300
  rrdatas      = [
    var.external_lb_ip
  ]
}
