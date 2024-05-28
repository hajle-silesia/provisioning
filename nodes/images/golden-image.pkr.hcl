packer {
  required_plugins {
    oracle = {
      source  = "github.com/hashicorp/oracle"
      version = "~> 1.0"
    }
  }
}

source "oracle-oci" "server" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  key_file     = var.key_file
  fingerprint  = var.fingerprint
  region       = var.region

  availability_domain = "ppDV:EU-FRANKFURT-1-AD-1"

  base_image_filter {
    display_name_search = "^Canonical-Ubuntu-22.04-aarch64-([\\.0-9-]+)$"
  }

  compartment_ocid     = "ocid1.tenancy.oc1..aaaaaaaablce6gcqz3rbcsp5sab27djnmzblcv4dtvvwtctl2toucgqcyeha"
  image_name           = "golden-image-${timestamp()}"
  shape                = "VM.Standard.A1.Flex"
  ssh_private_key_file = "certificates/ssh-key-2024-03-16.key"
  ssh_username         = "ubuntu"
  subnet_ocid          = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaavqfim5xlodlm3d5cusqs5quhokangy2kijercgywmgholp3wkl6q"
  shape_config {
    memory_in_gbs = 6
    ocpus         = 1
  }
  skip_create_image = false
}

build {
  sources = [
    "source.oracle-oci.server",
  ]

  provisioner "file" {
    source      = "nodes/images/create-server.sh"
    destination = "~/create-server.sh"
  }

  provisioner "shell" {
    environment_vars = [
      "K3S_VERSION=${var.k3s_version}",
      "K3S_TOKEN=${var.k3s_token}",
    ]
    inline = [
      "sudo bash ~/create-server.sh",
      "rm ~/create-server.sh",
    ]
  }
}
