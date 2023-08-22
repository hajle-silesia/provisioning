resource "random_id" "key_value_store" {
  prefix      = "key-value-store-"
  byte_length = 4
}

resource "google_sql_database_instance" "key_value_store" {
  name             = random_id.key_value_store.hex
  database_version = "POSTGRES_14"

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = 10

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }

    backup_configuration {
      enabled    = true
      start_time = "01:00"
    }

    maintenance_window {
      day  = 6
      hour = 1
    }

    database_flags {
      name  = "max_connections"
      value = 50
    }
  }

  deletion_protection = true
  depends_on          = [google_service_networking_connection.key_value_store]
}

resource "google_sql_database" "key_value_store" {
  name     = "key-value-store"
  instance = google_sql_database_instance.key_value_store.name
}

resource "google_sql_user" "key_value_store" {
  name     = "admin"
  instance = google_sql_database_instance.key_value_store.name
  password = random_password.key_value_store.result
}

resource "random_password" "key_value_store" {
  length  = 16
  special = false
}
