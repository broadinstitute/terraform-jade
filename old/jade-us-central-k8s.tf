module "k8s-master" {
  # terraform-shared repo
  source       = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-master?ref=k8s-cluster-monitoring-0.0.3-tf-0.12"
  dependencies = [module.enable-services]

  name                     = var.master_name
  location                 = var.region
  version_prefix           = var.version_prefix
  release_channel          = var.gke_release_channel
  network                  = google_compute_network.jade-network.name
  subnetwork               = google_compute_subnetwork.jade-subnetwork.name
  authorized_network_cidrs = var.broad_range_cidrs
  ip_allocation_policy = {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  private_ipv4_cidr_block  = var.private_ipv4_cidr_block
  enable_workload_identity = var.enable_workload_identity
}

module "k8s-nodes" {
  # terraform-shared repo
  source       = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-node-pool?ref=k8s-cluster-monitoring-0.0.3-tf-0.12"
  dependencies = [module.enable-services, module.k8s-master]

  name                     = var.node_name
  master_name              = var.master_name
  location                 = var.region
  node_count               = var.node_count
  machine_type             = var.machine_type
  disk_size_gb             = var.disk_size_gb
  labels                   = var.node_labels
  tags                     = var.node_tags
  enable_workload_identity = var.enable_workload_identity
}

module "k8s-nodes-2" {
  # terraform-shared repo
  source       = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-node-pool?ref=k8s-cluster-monitoring-0.0.3-tf-0.12"
  dependencies = [module.enable-services, module.k8s-master]

  name                     = "${var.node_name}-2"
  master_name              = var.master_name
  location                 = var.region
  node_count               = var.node_count
  machine_type             = var.machine_type
  disk_size_gb             = var.disk_size_gb
  labels                   = var.node_labels
  tags                     = var.node_tags
  enable_workload_identity = var.enable_workload_identity
}

module "k8s-nodes-3" {
  # terraform-shared repo
  source       = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-node-pool?ref=k8s-cluster-monitoring-0.0.3-tf-0.12"
  dependencies = [module.enable-services, module.k8s-master]

  name                     = "${var.node_name}-3"
  master_name              = var.master_name
  location                 = var.region
  node_count               = var.node_count
  machine_type             = var.machine_type
  disk_size_gb             = var.disk_size_gb
  labels                   = var.node_labels
  tags                     = var.node_tags
  enable_workload_identity = var.enable_workload_identity
}

module "k8s-nodes-4" {
  # terraform-shared repo
  source       = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-node-pool?ref=k8s-cluster-monitoring-0.0.3-tf-0.12"
  dependencies = [module.enable-services, module.k8s-master]

  name                     = "${var.node_name}-4"
  master_name              = var.master_name
  location                 = var.region
  node_count               = var.node_count
  machine_type             = var.machine_type
  disk_size_gb             = var.disk_size_gb
  labels                   = var.node_labels
  tags                     = var.node_tags
  enable_workload_identity = var.enable_workload_identity
}
