# Global Ip, CNAME, A Record
data google_dns_managed_zone dns_zone {
  count      = var.ip_only ? 0 : 1
  provider   = google-beta.datarepo-dns
  name       = var.dns_zone
}


resource google_compute_global_address global_ip_address {
  count    = var.ip_only ? 1 : 0
  provider = google.target
  name = "${each.value}-ip"
  depends_on = [var.dependencies]
}

resource google_dns_record_set a_dns {
  count      = var.ip_only ? 0 : 1
  provider = google-beta.datarepo-dns
  type = "A"
  ttl = "300"

  managed_zone = var.zone_gcp_name
  name = "${each.value}-global.${var.zone_dns_name}"
  rrdatas = [google_compute_global_address.global_ip_address[each.value].address]
  depends_on = [var.dependencies,data.google_dns_managed_zone.dns_zone]
}

resource google_dns_record_set cname_dns {
  count      = var.ip_only ? 0 : 1
  provider = google-beta.datarepo-dns
  type = "CNAME"
  ttl = "300"

  managed_zone = var.zone_gcp_name
  name = "${each.value}.${var.zone_dns_name}"
  rrdatas = [google_dns_record_set.a_dns[each.value].name]
  depends_on = [var.dependencies,data.google_dns_managed_zone.dns_zone]
}
