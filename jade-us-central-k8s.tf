module "my-k8s-master" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s?ref=k8s-master-0.1.0-tf-0.12"
  dependencies = [module.enable-services]

  providers = {
    google = "google-beta.new"
  }

  name = var.master_name
  location = var.region
  version_prefix = var.version_prefix
  network = google_compute_network.jade-network.name
  subnetwork = google_compute_subnetwork.jade-subnetwork.name
  authorized_network_cidrs = var.broad_range_cidrs
  private_ipv4_cidr_block = var.private_ipv4_cidr_block
}

module "my-k8s-nodes" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s?ref=k8s-node-pool-0.1.0-tf-0.12"
  dependencies = [module.enable-services]

  providers = {
    google = "google-beta.new"
  }

  name = var.node_name
  master_name = var.master_name
  location = var.region
  node_count = var.node_count
  machine_type = var.machine_type
  disk_size_gb = var.disk_size_gb
  labels = var.node_labels
  tags = var.node_tags
}
