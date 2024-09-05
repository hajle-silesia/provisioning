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

  compartment_ocid     = var.tenancy_ocid
  image_name           = "golden-image-${timestamp()}"
  shape                = "VM.Standard.A1.Flex"
  ssh_private_key_file = "certificates/ssh-key-2024-03-16.key"
  ssh_username         = "ubuntu"
  subnet_ocid          = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaa7s6w2fwhae3f4donkjxa5nibxbmca6fls3smhlubx2laxynhheba"
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
    source      = "machine-images/scripts/create-server-golden-image.sh"
    destination = "~/create-server-golden-image.sh"
  }

  provisioner "file" {
    source      = "machine-images/scripts/user-data.sh"
    destination = "~/user-data.sh"
  }

  provisioner "shell" {
    execute_command = "sudo bash -c '{{ .Vars }} {{ .Path }}'"
    environment_vars = [
      "K3S_VERSION=${var.k3s_version}",
      "K3S_TOKEN=${var.k3s_token}",
      "INTERNAL_LB=${var.internal_lb}",
      "COMPARTMENT_OCID=${var.tenancy_ocid}",
      "AVAILABILITY_DOMAIN=${var.availability_domain}",
    ]
    scripts = [
      "machine-images/scripts/create-server-golden-image.sh",
    ]
  }
}
