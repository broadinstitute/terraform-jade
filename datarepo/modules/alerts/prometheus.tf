# Global Ip, CNAME, A Record
data "google_dns_managed_zone" "dns_zone" {
  count    = var.ip_only ? 0 : 1
  provider = google-beta.datarepo-dns
  name     = var.dns_zone
}

locals {
  dns_zone_name = var.dns_zone_name == "" ? data.google_dns_managed_zone.dns_zone[0].dns_name : var.dns_zone_name
}

# grafana
resource "google_compute_global_address" "global_ip_address_grafana" {
  provider = google.target
  name     = "datarepo-grafana-ip"
}

resource "google_dns_record_set" "grafana_a_dns" {
  count    = var.ip_only ? 0 : 1
  provider = google-beta.datarepo-dns
  type     = "A"
  ttl      = "300"

  managed_zone = var.dns_zone
  name         = "datarepo-grafana.${local.dns_zone_name}"
  rrdatas      = [google_compute_global_address.global_ip_address_grafana.address]
  depends_on   = [data.google_dns_managed_zone.dns_zone]
}

# prometheus
resource "google_compute_global_address" "global_ip_address_prometheus" {
  provider = google.target
  name     = "datarepo-prometheus-ip"
}

resource "google_dns_record_set" "prometheus_a_dns" {
  count    = var.ip_only ? 0 : 1
  provider = google-beta.datarepo-dns
  type     = "A"
  ttl      = "300"

  managed_zone = var.dns_zone
  name         = "datarepo-prometheus.${local.dns_zone_name}"
  rrdatas      = [google_compute_global_address.global_ip_address_prometheus.address]
  depends_on   = [data.google_dns_managed_zone.dns_zone]
}

# workload identity GSA to KSA binding, this is a 1:1 so 1 GSA to KSA
module "prometheus_workloadid" {
  source = "github.com/broadinstitute/terraform-jade.git//datarepo/modules/workloadidentity?ref=master"
  providers = {
    google.target      = google.target
    google-beta.target = google-beta.target
  }

  google_project = var.google_project
  roles          = var.roles
  gsa_name       = var.gsa_name
  ksa_name       = var.ksa_name
  namespace      = var.monitoring_namespace
}
