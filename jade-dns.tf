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

resource "google_dns_record_set" "jade-a-dns" {
  provider     = google.broad-jade
  managed_zone = data.google_dns_managed_zone.dns_zone.name
  name         = "jade-global-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type         = "A"
  ttl          = "300"
  rrdatas      = [google_compute_global_address.jade-k8-ip.address]
}

resource "google_dns_record_set" "jade-cname-jade-dns-external" {
    provider      = google.broad-jade
    count         = "${var.env != var.suffix ? "1" : "0"}"
    managed_zone  = data.google_dns_managed_zone.dns_zone.name
    name          = "jade-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type          = "CNAME"
    ttl           = "300"
    rrdatas       = ["jade-global-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"]
    depends_on    = [google_dns_record_set.jade-a-dns]
}

resource "google_dns_record_set" "jade-cname-jade-dns-local" {
    provider      = google.broad-jade
    count         = "${var.env == var.suffix ? "1" : "0"}"
    managed_zone  = data.google_dns_managed_zone.dns_zone.name
    name          = "jade.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type          = "CNAME"
    ttl           = "300"
    rrdatas       = ["jade-global-${var.suffix}.${data.google_dns_managed_zone.dns_zone.dns_name}"]
    depends_on    = [google_dns_record_set.jade-a-dns]
}
