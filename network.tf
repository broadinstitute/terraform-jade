resource "google_compute_network" "jade-network" {
  project = "${var.google_project}"
  provider      = "google"
  name          = "${var.k8_network_name}"
  auto_create_subnetworks = "true"
}

resource "google_compute_subnetwork" "jade-subnetwork" {
  project = "${var.google_project}"
  provider      = "google"
  name          = "${var.k8_subnet_name}"
  ip_cidr_range = "10.0.0.0/22"
  region        = "us-central1"
  network       = "${google_compute_network.jade-network.self_link}"
}

data "google_dns_managed_zone" "jade_zone" {
  provider            = "google"
  name = "datarepo-${var.env}"
}
