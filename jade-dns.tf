data "google_dns_managed_zone" "dns_zone" {
    provider     = google.broad-jade
    project      = var.env_project
    name         = "datarepo-${var.env}"
}
#
# jade Service - DNS A Record and Public IP
#

# Public IP Address
resource "google_compute_global_address" "jade-k8-ip" {
  provider     = google
  name        = "jade-k8-100"
  depends_on  = [module.enable-services]
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

resource "google_dns_record_set" "jade-cname-jade-dns-external" {
    provider      = google.broad-jade
    count         = "${var.env != var.suffix ? "1" : "0"}"
    managed_zone  = data.google_dns_managed_zone.dns_zone.name
    name          = "jade-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type          = "CNAME"
    ttl           = "300"
    rrdatas       = ["jade-global-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"]
}

resource "google_dns_record_set" "jade-cname-jade-dns-local" {
    provider      = google.broad-jade
    count         = "${var.env == var.suffix ? "1" : "0"}"
    managed_zone  = data.google_dns_managed_zone.dns_zone.name
    name          = "jade.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type          = "CNAME"
    ttl           = "300"
    rrdatas       = ["jade-global-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"]
}

# Public IP Address for Grafana Ingress
resource "google_compute_global_address" "grafana-k8-ip" {
  provider     = google
  name        = "grafana-k8-100"
  depends_on  = [module.enable-services]
}

resource "google_dns_record_set" "grafana-cname-grafana-dns-external" {
    provider      = google.broad-jade
    count         = "${var.env != var.suffix ? "1" : "0"}"
    managed_zone  = data.google_dns_managed_zone.dns_zone.name
    name          = "grafana-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type          = "CNAME"
    ttl           = "300"
    rrdatas       = ["grafana-global-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"]
}

resource "google_dns_record_set" "grafana-cname-grafana-dns-local" {
    provider      = google.broad-jade
    count         = "${var.env == var.suffix ? "1" : "0"}"
    managed_zone  = data.google_dns_managed_zone.dns_zone.name
    name          = "grafana.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type          = "CNAME"
    ttl           = "300"
    rrdatas       = ["grafana-global-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"]
}
