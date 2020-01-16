
variable "api-roles" {
  type = list(string)
  default = [
  "roles/bigquery.admin",
  "roles/cloudsql.admin",
  "roles/datastore.user",
  "roles/errorreporting.writer",
  "roles/logging.logWriter",
  "roles/monitoring.admin",
  "roles/servicemanagement.serviceController",
  "roles/stackdriver.accounts.viewer",
  "roles/storage.admin"
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
  for_each = toset(var.api-roles)
  project = var.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.jade-api-service-account.email}"
  depends_on = [google_service_account.jade-api-service-account]
}

resource "vault_generic_secret" "jade-api-sa-key-secret" {
    path      = "secret/dsde/datarepo/${var.env}/api-sa-${var.suffix}-b64"
#    data_json = base64decode(google_service_account_key.sql-sa-key.private_key)
    data_json =  <<EOT
{
    "sa": "${google_service_account_key.jade-api-sa-key.private_key}"
}
EOT
}
