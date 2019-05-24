data "google_dns_managed_zone" "dns_zone" {
    provider     = "google.broad-jade-${var.env_project}"
    project             = "${var.env_project}"
    name                = "${var.env_project}"
}
#
# jade Service - DNS A Record and Public IP
#

# Public IP Address
resource "google_compute_global_address" "jade-k8-ip" {
  provider = "google"
  name = "jade-k8-100"
  depends_on = ["module.enable-services"]
}

resource "google_dns_record_set" "jade-a-dns" {
  provider     = "google.broad-jade-${var.env_project}"
  managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
  name         = "jade-global.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type         = "A"
  ttl          = "300"
  rrdatas      = [ "${google_compute_global_address.jade-k8-ip.address}" ]
  depends_on = ["google_dns_managed_zone.dns_zone"]
}

resource "google_dns_record_set" "jade-cname-jade-dns" {
    provider = "google.broad-jade-${var.env_project}"
    managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
    name = "jade.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type = "CNAME"
    ttl = "300"
    rrdatas = ["jade-global.${data.google_dns_managed_zone.dns_zone.dns_name}"]
    depends_on = ["google_dns_record_set.jade-a-dns"]
}
