resource "google_compute_network" "jade-network" {
  project = "${var.project}"
  provider      = "google"
  name          = "${var.k8_network_name}"
  auto_create_subnetworks = "true"
  depends_on = ["module.enable-services"]
}

resource "google_compute_subnetwork" "jade-subnetwork" {
  project = "${var.project}"
  provider      = "google"
  name          = "${var.k8_subnet_name}"
  ip_cidr_range = "10.0.0.0/22"
  region        = "us-central1"
  network       = "${google_compute_network.jade-network.self_link}"
  depends_on = ["module.enable-services"]
}

resource "google_dns_managed_zone" "dns_zone" {
  provider = "google"
  name = "datarepo-${var.env}"
  dns_name = "datarepo-${var.env}.broadinstitute.org."
  depends_on = ["module.enable-services"]
}
