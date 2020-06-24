# Global Ip, CNAME, A Record
data google_dns_managed_zone dns_zone {
  provider   = google-beta.datarepo-dns
  name       = var.dns_zone
  depends_on = [var.dependencies]
}

module datarepo_dns_names {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/external-dns?ref=external-dns-0.0.3"
  providers = {
    google.ip  = google-beta.target,
    google.dns = google-beta.datarepo-dns
  }
  dependencies  = var.dependencies
  zone_gcp_name = data.google_dns_managed_zone.dns_zone.name
  zone_dns_name = data.google_dns_managed_zone.dns_zone.dns_name
  dns_names     = var.dns_names
}
