resource "google_compute_ssl_policy" "global-ssl-policy" {
  name            = "global-ssl-policy"
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_network" "network" {
  count                   = var.enable ? 1 : 0
  project                 = var.google_project
  provider                = google.target
  name                    = var.k8_network_name
  auto_create_subnetworks = "true"
  depends_on              = [var.dependencies]
}

resource "google_compute_subnetwork" "subnetwork" {
  count                    = var.enable ? 1 : 0
  project                  = var.google_project
  provider                 = google.target
  name                     = var.k8_subnet_name
  ip_cidr_range            = "10.0.0.0/22"
  region                   = "us-central1"
  private_ip_google_access = true
  network                  = google_compute_network.network[0].self_link
  depends_on               = [var.dependencies]
  secondary_ip_range = [
    {
      range_name    = "pods"
      ip_cidr_range = var.gke_subnet_pods
    },
    {
      range_name    = "services"
      ip_cidr_range = var.gke_subnet_services
  }]
  dynamic "log_config" {
    for_each = var.enable_flow_logs ? ["If only TF supported if/else"] : []
    content {
      aggregation_interval = "INTERVAL_10_MIN"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

module "cloud-armor" {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloud-armor-rule?ref=Cloud-Armor-0.0.1"

  providers = {
    google.target = google-beta.target
  }
}
