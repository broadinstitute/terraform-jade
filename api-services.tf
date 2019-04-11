module "enable-services" {

  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=k8s-0.0.3"

  providers {
    google = "google-beta"
  }
  project = "${var.project}"
  services = [
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "genomics.googleapis.com",
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "dns.googleapis.com",
    "sql-component.googleapis.com",
    "monitoring.googleapis.com",
    "sqladmin.googleapis.com",
    "container.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}
