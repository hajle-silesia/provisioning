module "helper" {
  source  = "terraform-google-modules/iam/google//modules/helper"
  version = "~> 8.0"

  entities = ["my-project_one", "my-project_two"]
  mode     = "authoritative"

  bindings = {
    "roles/compute.networkAdmin" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
    ]
    "roles/appengine.appAdmin" = [
      "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
      "group:my-group@my-org.com",
      "user:my-user@my-org.com",
    ]
  }

  conditional_bindings = [
    {
      role        = "roles/editor"
      title       = "expires_after_2019_12_31"
      description = "Expiring at midnight of 2019-12-31"
      expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
      members     = ["user:my-user@my-org.com"]
    }
  ]
}

output "bindings" {
  value = module.helper.bindings_authoritative
}
