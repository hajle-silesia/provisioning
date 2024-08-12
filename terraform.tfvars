compartment_ocid = "ocid1.tenancy.oc1..aaaaaaaablce6gcqz3rbcsp5sab27djnmzblcv4dtvvwtctl2toucgqcyeha"
region           = "eu-frankfurt-1"

context = {
  enabled     = true
  namespace   = "hs"
  environment = "fra"
  stage       = "prod"
  name        = "network"
}

vcn = {
  name = "vcn"
  ipv4_cidr_blocks = [
    "10.20.0.0/16",
  ]
  dns_label                      = "default"
  default_security_list_deny_all = true
  default_route_table_no_routes  = true
  internet_gateway_enabled       = true
}

subnets = {
  eu-frankfurt-1 = {
    name                = "servers-subnet"
    ipv4_cidr_block     = "10.20.0.0/17"
    dns_label           = "servers"
    route_table_enabled = true
  }
}

shape = "VM.Standard.A1.Flex"

# agents = {
#   eu-frankfurt-1 = {
# availability_domains = [
#       "ppDV:EU-FRANKFURT-1-AD-1",
#       "ppDV:EU-FRANKFURT-1-AD-2",
#     ]
#     cidr_range = "10.20.128.0/17"
#   },
# }
