data "google_project" "project" {
}

resource "google_service_account" "node_pool" {
  account_id   = "gke-node-sa"
  display_name = "gke service account"
}

resource "google_project_iam_member" "node_pool" {
  count   = length(local.node_pool_gke_roles)
  project = var.google_project
  role    = element(local.node_pool_gke_roles, count.index)
  member  = "serviceAccount:${google_service_account.node_pool.email}"
}



resource "google_project_iam_binding" "kubernetes_engine_kms_access" {
  project = var.google_project
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
}

locals {
  # Roles needed for the node pool service account to run a GKE cluster.
  node_pool_gke_roles = [
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
    "roles/container.admin",
    "roles/compute.admin",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  ]
}
