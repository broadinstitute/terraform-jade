resource "google_dns_managed_zone" "dns_zone" {
  provider   = google
  count      = var.dns_zone_name != "" ? 1 : 0
  name       = var.dns_zone_name
  dns_name   = "${var.dns_zone_name}.broadinstitute.org."
  depends_on = [var.dependencies]

  dnssec_config {
    # on, off, transfer
    state = "on"

    # nsec, nsec3
    non_existence = "nsec3"
  }
}
