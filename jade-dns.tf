### START TEMP DNS
data "google_dns_managed_zone" "dns_zone" {
    provider     = google.broad-jade
    project      = var.env_project
    name         = "datarepo-${var.env}"
}

resource "google_compute_global_address" "jade-k8-ip-temp" {
  provider   = google
  name       = "jade-k8-100-temp"
  depends_on = [module.enable-services]
}

resource "google_dns_record_set" "jade-a-dns-temp" {
  provider     = google.broad-jade
  managed_zone = data.google_dns_managed_zone.dns_zone.name
  name         = "jade-global-${var.suffix}-temp.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type         = "A"
  ttl          = "300"
  rrdatas      = [google_compute_global_address.jade-k8-ip-temp.address]
}

resource "google_dns_record_set" "jade-cname-jade-dns-external-temp" {
    provider      = google.broad-jade
    managed_zone  = data.google_dns_managed_zone.dns_zone.name
    name          = "jade-temp.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type          = "CNAME"
    ttl           = "300"
    rrdatas       = ["jade-global-${var.suffix}-temp.${data.google_dns_managed_zone.dns_zone.dns_name}"]
    depends_on    = [google_dns_record_set.jade-a-dns-temp]
}
### END TEMP DNS

# Public IP Address
resource "google_compute_global_address" "jade-k8-ip" {
  provider   = google
  name       = "jade-k8-100"
  depends_on = [module.enable-services]
}

# Public IP Address for Grafana Ingress
resource "google_compute_global_address" "grafana-k8-ip" {
  provider   = google
  name       = "grafana-k8-100"
  depends_on = [module.enable-services]
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
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/external-dns?ref=external-dns-0.0.2-tf-0.12"

  target_project       = var.env_project
  region               = var.region
  target_credentials   = file("env_svc.json")
  target_dns_zone_name = "datarepo-${var.env}"
  records              = local.records
}
