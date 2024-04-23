output "servers_public_ips" {
  value = [for instance_data in data.oci_core_instance.data : instance_data.public_ip]
}
