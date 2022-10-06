
variable "api-roles" {
  type = list(string)
  default = [
    "roles/cloudsql.admin",
    "roles/datastore.user",
    "roles/errorreporting.writer",
    "roles/logging.logWriter",
    "roles/monitoring.admin",
    "roles/servicemanagement.serviceController",
    "roles/stackdriver.accounts.viewer",
    "roles/storage.admin",
    "roles/pubsub.admin"
  ]
}

variable "jadeteam-roles" {
  type = list(string)
  default = [
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/container.hostServiceAgentUser",
    "roles/cloudsql.admin",
    "roles/monitoring.admin",
    "roles/servicemanagement.serviceController",
    "roles/stackdriver.accounts.viewer",
    "roles/storage.admin"
  ]
}

variable "app_folder_roles" {
  type        = list(string)
  description = "Roles used to manage projects created by the resource buffer service"
  default = [
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.projectDeleter",
    "roles/owner"
  ]
}

variable "external_folder_ids" {
  type        = list(string)
  description = "Folder ids used by RBS"
  default = [
    "270278425081" # data.test-terra.bio/repos/jade-dev
  ]
}

locals {
  folder_ids_and_roles = [
    for pair in setproduct(var.app_folder_roles, var.external_folder_ids) : {
      folder_role = pair[0]
      folder_id   = pair[1]
    }
  ]
}

resource "google_service_account" "jade-api-service-account" {
  account_id   = "jade-api-sa"
  display_name = "jade-api server service account"
}

resource "google_service_account_key" "jade-api-sa-key" {
  service_account_id = google_service_account.jade-api-service-account.name
}

resource "google_project_iam_member" "jade-api-sa-roles" {
  for_each   = toset(var.api-roles)
  project    = data.google_project.project.name
  role       = each.key
  member     = "serviceAccount:${google_service_account.jade-api-service-account.email}"
  depends_on = [google_service_account.jade-api-service-account]
}

resource "google_folder_iam_member" "app_folder_roles" {
  count    = length(local.folder_ids_and_roles)
  provider = google
  folder   = local.folder_ids_and_roles[count.index].folder_id
  role     = local.folder_ids_and_roles[count.index].folder_role
  member   = "serviceAccount:${google_service_account.jade-api-service-account.email}"
}

resource "vault_generic_secret" "jade-api-sa-key-secret" {
  path = "secret/dsde/datarepo/${var.env}/api-sa-${var.suffix}-b64"
  #    data_json = base64decode(google_service_account_key.sql-sa-key.private_key)
  data_json = <<EOT
{
    "sa": "${google_service_account_key.jade-api-sa-key.private_key}"
}
EOT
}

resource "google_project_iam_member" "jadeteam-roles" {
  for_each = toset(var.jadeteam-roles)
  project  = data.google_project.project.name
  role     = each.key
  member   = "group:jadeteam@broadinstitute.org"
}
