# gcp networking, k8 cluster
module "core-infrastructure" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/core-infrastructure?ref=ms-datarepomodule"

  google_project  = var.google_project
  region          = var.region
  k8_network_name = var.k8_network_name
  k8_subnet_name  = var.k8_subnet_name
  node_count      = var.node_count
  machine_type    = var.machine_type
  version_prefix  = var.version_prefix

  providers = {
    google.target      = google
    google-beta.target = google-beta
  }
}

# dns ips, sql server and dbs
module "datarepo-app" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/datarepo-app?ref=ms-datarepomodule"

  dependencies = [module.core-infrastructure]

  google_project            = var.google_project
  dns_zone                  = var.dns_zone
  dns_names                 = var.dns_names
  db_version                = var.db_version
  environment               = var.environment
  private_network           = module.core-infrastructure.network-name
  private_network_self_link = module.core-infrastructure.network-self-link



  providers = {
    google.target            = google
    google-beta.target       = google-beta
    google-beta.datarepo-dns = google-beta.dns
    vault.target             = vault.broad
  }
}
