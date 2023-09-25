resource "google_secret_manager_secret" "key" {
  secret_id = "key"

  labels = {
    type = "secret"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "key" {
  secret = google_secret_manager_secret.key.id
  secret_data = "Super secret information!!!"
}
