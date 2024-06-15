tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaablce6gcqz3rbcsp5sab27djnmzblcv4dtvvwtctl2toucgqcyeha"
user_ocid        = "ocid1.user.oc1..aaaaaaaanb4hbpro6ncmqwomnv2yei5fuu3pnxrr5xuper766vov6lyt4bda"
private_key_path = "certificates/mtweeman@gmail.com_2024-03-02T19_23_13.049Z.pem"
fingerprint      = "a3:1c:b7:cb:dd:a2:ac:b2:66:c8:b0:b6:c9:18:0b:bc"
region           = "eu-frankfurt-1"

compartment_ocid = "ocid1.tenancy.oc1..aaaaaaaablce6gcqz3rbcsp5sab27djnmzblcv4dtvvwtctl2toucgqcyeha"

network_cidr_range = "10.20.0.0/16"
shape              = "VM.Standard.A1.Flex"

servers = {
  eu-frankfurt-1 = {
    availability_domains = [
      "ppDV:EU-FRANKFURT-1-AD-1",
      "ppDV:EU-FRANKFURT-1-AD-2",
      "ppDV:EU-FRANKFURT-1-AD-3",
    ]
    cidr_range = "10.20.0.0/17"
  },
}

# agents = {
#   eu-frankfurt-1 = {
# availability_domains = [
#       "ppDV:EU-FRANKFURT-1-AD-1",
#       "ppDV:EU-FRANKFURT-1-AD-2",
#     ]
#     cidr_range = "10.20.128.0/17"
#   },
# }
