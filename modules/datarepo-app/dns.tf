# Global Ip, CNAME, A Record
data google_dns_managed_zone dns_zone {
  count      = var.dns_zone == "" ? 0 : 1
  provider   = google-beta.datarepo-dns
  name       = var.dns_zone
}

module datarepo_dns_names {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/external-dns?ref=external-dns-0.0.3"
  providers = {
    google.ip  = google-beta.target,
    google.dns = google-beta.datarepo-dns
  }
  dependencies  = [data.google_dns_managed_zone.dns_zone]
  zone_gcp_name = data.google_dns_managed_zone.dns_zone[0].name
  zone_dns_name = data.google_dns_managed_zone.dns_zone[0].dns_name
  dns_names     = var.dns_names
}

## ip only for terra
resource google_compute_global_address global_ip_address {
  count = var.ip_only == true ? 1 : 0

  provider = vault.target
  name = "${var.environment}-ip"
  depends_on = [var.dependencies]
}
