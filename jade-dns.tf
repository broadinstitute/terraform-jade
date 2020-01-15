
# Public IP Address
resource "google_compute_global_address" "jade-k8-ip" {
  provider     = google
  name        = "jade-k8-100"
  depends_on  = [module.enable-services]
}

# Public IP Address for Grafana Ingress
resource "google_compute_global_address" "grafana-k8-ip" {
  provider     = google
  name        = "grafana-k8-100"
  depends_on  = [module.enable-services]
}

resource "google_compute_global_address" "sql_private_ip_address" {
  provider = "google-beta"

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.jade-network.self_link
}

module "dns-set" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/external-dns?ref=external-dns-0.0.2-tf-0.12"

  target_project = var.env_project
  region = var.region
  target_credentials = file("${var.env}_svc.json")
  target_dns_zone_name = "datarepo-${var.env}"
  records = local.records
}
