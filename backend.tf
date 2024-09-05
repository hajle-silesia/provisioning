terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket                      = "backend"
    region                      = "eu-frankfurt-1"
    key                         = "state/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    use_path_style              = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
    endpoints = {
      s3 = "https://fru7nifnglug.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    }
  }
}
