
# Create a NAT router for k8s so nodes can interact with external services as a static IP.
data "google_project" "project" {
}

resource "google_compute_router" "router" {
  count    = var.enable ? 1 : 0
  provider = google.target
  name     = "router"
  project  = data.google_project.project.name
  network  = google_compute_network.jade-network[0].self_link

  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "nat-address" {
  count    = var.enable ? 2 : 0
  provider = google.target
  name     = "nat-external-${count.index}"
  project  = data.google_project.project.name
}

resource "google_compute_router_nat" "nat" {
  count    = var.enable ? 1 : 0
  provider = google.target
  name     = "nat-1"
  project  = data.google_project.project.name
  router   = google_compute_router.router[0].name

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.nat-address[*].self_link

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
