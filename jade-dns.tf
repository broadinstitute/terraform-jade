#
# jade Service - DNS A Record and Public IP
#

# Public IP Address
resource "google_compute_global_address" "jade-k8-ip" {
  provider = "google"
  name = "jade-k8-100"
}

resource "google_dns_record_set" "jade-100-jade-dns" {
  provider     = "google"
  managed_zone = "${google_dns_managed_zone.jade_zone.name}"
  name         = "${format("jade-k8-1%02d.%s", count.index+1, google_dns_managed_zone.jade_zone.dns_name)}"
  type         = "A"
  ttl          = "300"
  rrdatas      = [ "${google_compute_global_address.jade-k8-ip.address}" ]
}
