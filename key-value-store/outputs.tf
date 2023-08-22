output "key_value_store_ip" {
  value = google_sql_database_instance.key_value_store.private_ip_address
}

output "key_value_store_name" {
  value = google_sql_database.key_value_store.name
}

output "key_value_store_user" {
  value = google_sql_user.key_value_store.name
}

output "key_value_store_password" {
  value = google_sql_user.key_value_store.password
}
