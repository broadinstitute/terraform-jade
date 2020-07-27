module "enable-services" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-0.3.0-tf-0.12"

  providers = {
    google.target = google-beta
  }
  project = var.google_project
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

# gcp networking, k8 cluster
module "core-infrastructure" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/core-infrastructure?ref=datarepo-modules-0.0.1"

  dependencies = [module.enable-services]

  google_project  = var.google_project
  region          = var.region
  k8_network_name = var.k8_network_name
  k8_subnet_name  = var.k8_subnet_name
  node_count      = var.node_count
  machine_type    = var.machine_type
  version_prefix  = var.version_prefix
  dns_zone_name   = var.dns_zone


  providers = {
    google.target      = google
    google-beta.target = google-beta
  }
}

# dns ips, sql server and dbs
module "datarepo-app" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/datarepo-app?ref=ms-stage-prod"

  dependencies = [module.core-infrastructure]

  google_project            = var.google_project
  db_version                = var.db_version
  environment               = var.environment
  workloadid_names          = local.workloadid_names
  enable_private_services   = var.enable_private_services
  private_network_self_link = module.core-infrastructure.network-self-link
  ip_only                   = var.ip_only

  providers = {
    google.target            = google
    google-beta.target       = google-beta
    vault.target             = vault.broad
  }
}