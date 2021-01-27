module "k8s-master" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-master?ref=k8s-master-0.2.5"
  depends_on = [google_compute_network.network, google_compute_subnetwork.subnetwork]

  name                     = local.master_name
  project                  = var.google_project
  location                 = var.master_region
  version_prefix           = var.version_prefix
  release_channel          = var.gke_release_channel
  network                  = var.k8_network_name
  subnetwork               = var.k8_subnet_name
  authorized_network_cidrs = local.broad_range_cidrs
  ip_allocation_policy = {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  private_ipv4_cidr_block     = var.private_ipv4_cidr_block
  enable_workload_identity    = var.enable_workload_identity
  enable_shielded_nodes       = var.enable_shielded_nodes
  enable_binary_authorization = var.enable_binary_authorization
}

module "k8s-cis-nodes" {
  # terraform-shared repo
  source     = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-node-pool?ref=k8s-master-0.2.5"
  for_each   = var.node_regions
  depends_on = [module.k8s-master, google_service_account.node_pool]

  name                     = "${each.key}-cis"
  master_name              = local.master_name
  location                 = each.value.region
  node_count               = var.node_count
  machine_type             = var.machine_type
  disk_size_gb             = var.disk_size_gb
  labels                   = local.node_labels
  tags                     = local.node_tags
  enable_workload_identity = var.enable_workload_identity
  service_account          = google_service_account.node_pool.email
  enable_secure_boot       = var.enable_secure_boot
}
