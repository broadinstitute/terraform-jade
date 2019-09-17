resource "google_service_account" "sql-service-account" {
  account_id   = "proxy-sa"
  display_name = "sqlproxy service account"
}

resource "google_service_account_key" "sql-sa-key" {
    service_account_id = google_service_account.sql-service-account.name
}

resource "google_project_iam_member" "sql-sa-role" {
    project = var.project
    role    = "roles/cloudsql.client"
    member  = "serviceAccount:${google_service_account.sql-service-account.email}"
}

resource "vault_generic_secret" "sql-sa-key-secret" {
    path      = "secret/dsde/datarepo/${var.env}/proxy-sa-${var.suffix}.json"
    data_json = base64decode(google_service_account_key.sql-sa-key.private_key)
}

#separate backup account
resource "google_service_account" "sql-backup-account" {
  account_id   = "sql-backup-sa"
  display_name = "sql backup service account"
}

resource "google_service_account_key" "sql-backup-key" {
    service_account_id = google_service_account.sql-backup-account.name
}

resource "google_project_iam_member" "sql-backup-role" {
    project = var.project
    role    = "roles/cloudsql.client"
    member  = "serviceAccount:${google_service_account.sql-backup-account.email}"
}

resource "vault_generic_secret" "sql-backup-key-secret" {
    path      = "secret/dsde/datarepo/${var.env}/sql-backup-sa-${var.suffix}.json"
    data_json = base64decode(google_service_account_key.sql-backup-key.private_key)
}
