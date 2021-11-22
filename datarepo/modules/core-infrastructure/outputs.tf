#
# Service Account Outputs
#

#
# CloudSQL PostgreSQL Outputs
#

output "network-name" {
  value = var.enable ? google_compute_network.network[0].name : null
}
output "network-self-link" {
  value = var.enable ? google_compute_network.network[0].self_link : null
}
output "subnetwork" {
  value = var.enable ? google_compute_subnetwork.subnetwork[0].name : null
}
output "dns-zone-name" {
  value = var.google_project == "broad-jade-perf" ? google_dns_managed_zone.dns_zone[0].dns_name : null
}
