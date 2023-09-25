resource "google_dns_managed_zone" "hajlesilesia_online" {
  name          = "hajlesilesia-online"
  dns_name      = "hajlesilesia.online."
  description   = "hajlesilesia Public DNS zone"
  force_destroy = "true"
}

resource "google_dns_record_set" "a" {
  name         = google_dns_managed_zone.hajlesilesia_online.dns_name
  managed_zone = google_dns_managed_zone.hajlesilesia_online.name
  type         = "A"
  ttl          = 300
  rrdatas      = [
    var.external_lb_ip
  ]
}

resource "google_dns_record_set" "soa" {
  name         = google_dns_managed_zone.hajlesilesia_online.dns_name
  managed_zone = google_dns_managed_zone.hajlesilesia_online.name
  type         = "SOA"
  ttl          = 21600
  rrdatas      = [
    "dns.home.pl. mtweeman.gmail.com. 1 21600 3600 259200 300",
  ]
}

resource "google_dns_record_set" "ns" {
  name         = google_dns_managed_zone.hajlesilesia_online.dns_name
  managed_zone = google_dns_managed_zone.hajlesilesia_online.name
  type         = "NS"
  ttl          = 21600
  rrdatas      = [
    "dns.home.pl.",
    "dns2.home.pl.",
    "dns3.home.pl.",
  ]
}
