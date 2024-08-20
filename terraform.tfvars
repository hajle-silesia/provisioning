compartment_ocid = "ocid1.tenancy.oc1..aaaaaaaablce6gcqz3rbcsp5sab27djnmzblcv4dtvvwtctl2toucgqcyeha"
region           = "eu-frankfurt-1"

context = {
  enabled     = true
  namespace   = "hs"
  stage       = "prod"
  environment = "fra"
  name        = "network"
}

subnets = {
  "eu-frankfurt-1" = null
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
