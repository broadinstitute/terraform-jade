resource "google_compute_network" "jade-network" {
  project                 = data.google_project.project.name
  provider                = google
  name                    = var.k8_network_name
  auto_create_subnetworks = "true"
  depends_on              = [module.enable-services]
}

resource "google_compute_subnetwork" "jade-subnetwork" {
  project                  = data.google_project.project.name
  provider                 = google
  name                     = var.k8_subnet_name
  ip_cidr_range            = "10.0.0.0/22"
  region                   = "us-central1"
  private_ip_google_access = true
  network                  = google_compute_network.jade-network.self_link
  depends_on               = [module.enable-services]
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

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = google_compute_network.jade-network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.sql_private_ip_address.name]
}

module "cloud-armor" {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloud-armor-rule?ref=Cloud-Armor-0.0.1"

  providers = {
    google.target = google-beta
  }
}


resource "google_compute_ssl_policy" "global-ssl-policy" {
  name            = "global-ssl-policy"
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
}
