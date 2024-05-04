output "data" {
  value = {for instance_data in data.oci_core_instance.data : instance_data.display_name => instance_data.public_ip}
}
