output "servers" {
  value = {
    "hosts" : {
      for server_name, public_ip in module.servers["eu-frankfurt-1"].data : server_name => { ansible_host = public_ip }
    }
  }
}
