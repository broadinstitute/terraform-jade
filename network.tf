resource "google_compute_network" "jade-network" {
  project                 = var.project
  provider                = google
  name                    = var.k8_network_name
  auto_create_subnetworks = "true"
  depends_on              = [module.enable-services]
}

resource "google_compute_subnetwork" "jade-subnetwork" {
  project                  = var.project
  provider                 = google
  name                     = var.k8_subnet_name
  ip_cidr_range            = "10.0.0.0/22"
  region                   = "us-central1"
  private_ip_google_access = true
  network                  = google_compute_network.jade-network.self_link
  depends_on               = [module.enable-services]

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

resource "google_dns_managed_zone" "dns_zone" {
  provider   = google
  count      = "${var.env == var.suffix ? "1" : "0"}"
  name       = "datarepo-${var.env}"
  dns_name   = "datarepo-${var.env}.broadinstitute.org."
  depends_on = [module.enable-services]
}
