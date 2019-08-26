module "my-k8s-cluster" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s?ref=k8s-0.1.4-tf-0.12"
  dependencies = [module.enable-services]

  providers = {
    google = "google-beta"
  }
  # Name for your cluster (use dashes not underscores)
  cluster_name = var.k8s_cluster_name
  # Network where the cluster will live (must be full resource path)
  cluster_network = google_compute_network.jade-network.name

  # Subnet where the cluster will live (must be full resource path)
  cluster_subnetwork = google_compute_subnetwork.jade-subnetwork.name

  # CIDR to use for the hosted master netwok. must be a /28 that does NOT overlap with the network k8s is on
  private_master_ipv4_cidr_block = "10.127.0.0/28"

  # CIDRs of networks allowed to talk to the k8s master
  master_authorized_network_cidrs = var.broad_range_cidrs

  # k8s_version for master and nodes
  k8s_version = var.k8s_version

  #instance size
  node_pool_machine_type = var.jade_k8s_node_pool_machine_type

  # number of nodes in your node pool
  node_pool_count = var.node_pool_count
}
