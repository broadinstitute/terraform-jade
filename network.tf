resource "google_compute_network" "jade-network" {
  project                 = var.project
  provider                = google
  name                    = var.k8_network_name
  auto_create_subnetworks = "true"
  depends_on = [module.enable-services]
}

resource "google_compute_subnetwork" "jade-subnetwork" {
  project           = var.project
  provider          = google
  name              = var.k8_subnet_name
  ip_cidr_range     = "10.0.0.0/22"
  region            = "us-central1"
  enable_flow_logs  = true
  private_ip_google_access = true
  network           = google_compute_network.jade-network.self_link
  depends_on        = [module.enable-services]
}

resource "google_compute_global_address" "sql_private_ip_address" {
  provider = "google-beta"

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.jade-network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = google_compute_network.jade-network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.sql_private_ip_address.name]
}

resource "google_dns_managed_zone" "dns_zone" {
  provider    = google
  count       = "${var.env == var.suffix ? "1" : "0"}"
  name        = "datarepo-${var.env}"
  dns_name    = "datarepo-${var.env}.broadinstitute.org."
  depends_on  = [module.enable-services]
}




# Create a NAT router for k8s so nodes can interact with external services as a static IP.

resource "google_compute_router" "router" {
  name = "${var.k8s_cluster_name}-router"
  project = var.project
  network = google_compute_network.jade-network.self_link

  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "nat-address" {
  count = 2
  name = "${var.k8s_cluster_name}-nat-external-${count.index}"
  project = var.project
  depends_on = [module.enable-services]
}

resource "google_compute_router_nat" "nat" {
  name = "${var.k8s_cluster_name}-nat-1"
  project = var.project
  router = google_compute_router.router.name

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = google_compute_address.nat-address[*].self_link

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
