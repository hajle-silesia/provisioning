resource "google_project_service" "custom" {
  for_each = toset([
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "dns.googleapis.com",
    "osconfig.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
  ])

  service = each.value

  disable_on_destroy = false
}
