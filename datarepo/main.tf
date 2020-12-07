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
    "servicenetworking.googleapis.com",
    "stackdriver.googleapis.com",
    "logging.googleapis.com"
  ]
}

# gcp networking, k8 cluster
module "core-infrastructure" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/core-infrastructure?ref=master"

  dependencies = [module.enable-services]

  master_region    = var.region
  node_regions     = var.node_regions
  google_project   = var.google_project
  k8_network_name  = var.k8_network_name
  k8_subnet_name   = var.k8_subnet_name
  node_count       = var.node_count
  machine_type     = var.machine_type
  version_prefix   = var.version_prefix
  dns_zone_name    = var.dns_zone
  argocd_cidrs     = var.argocd_cidrs
  enable_flow_logs = var.enable_flow_logs

  providers = {
    google.target      = google
    google-beta.target = google-beta
  }
}
# dns ips, sql server and dbs
module "datarepo-app" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/datarepo-app?ref=fb-dr-1502-pg-max-connections"

  dependencies = [module.core-infrastructure]

  google_project            = var.google_project
  dns_name                  = var.dns_name
  db_version                = var.db_version
  postgres_max_connections  = var.postgres_max_connections
  environment               = var.environment
  workloadid_names          = local.workloadid_names
  enable_private_services   = var.enable_private_services
  private_network_self_link = module.core-infrastructure.network-self-link
  ip_only                   = var.ip_only
  dns_zone                  = var.dns_zone
  cloudsql_tier             = var.cloudsql_tier

  providers = {
    google.target            = google
    google-beta.target       = google-beta
    google-beta.datarepo-dns = google-beta
    vault.target             = vault.broad
  }
}

# alerts
module "datarepo-alerts" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/alerts?ref=master"

  dependencies = [module.datarepo-app]

  google_project    = var.google_project
  environment       = var.environment
  host              = var.host
  path              = "/"
  token_secret_path = var.token_secret_path
  roles             = var.roles
  gsa_name          = var.gsa_name
  ksa_name          = var.ksa_name
  namespace         = var.namespace
  ip_only           = var.ip_only
  dns_zone          = var.dns_zone

  providers = {
    google.target            = google
    google-beta.target       = google-beta
    vault.target             = vault.broad
    google-beta.datarepo-dns = google-beta
  }
}

# monitoring audit and proformance logs to bq and gcs bucket
module "datarepo-monitoring" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/production-monitoring?ref=master"

  dependencies = [module.datarepo-app]

  google_project  = var.google_project
  environment     = var.environment
  enable_bigquery = var.enable_bigquery
  enable_gcs      = var.enable_gcs
  enable_pubsub   = var.enable_pubsub
  enable          = var.enable_monitoring

  providers = {
    google.target      = google
    google-beta.target = google-beta
  }
}
