module "core-infrastructure" {
  source = "github.com/broadinstitute/terraform-jade.git//modules/core-infrastructure?ref=ms-datarepomodule"

  google_project  = var.google_project
  region          = var.region
  k8_network_name = var.k8_network_name
  k8_subnet_name  = var.k8_subnet_name
  node_count      = var.node_count
  machine_type    = var.machine_type

  providers = {
    google.target      = google
    google-beta.target = google-beta
  }
}
