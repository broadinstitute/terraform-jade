resource "google_service_account" "grafana-service-account" {
  account_id   = "grafana-sa"
  display_name = "grafana monitor service account"
}

resource "google_service_account_key" "grafana-sa-key" {
  service_account_id = google_service_account.grafana-service-account.name
}

resource "google_project_iam_member" "grafana-sa-monitoring-role" {
  project = data.google_project.project.name
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.grafana-service-account.email}"
}

resource "google_project_iam_member" "grafana-sa-bqviewer-role" {
  project = data.google_project.project.name
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.grafana-service-account.email}"
}

resource "google_project_iam_member" "grafana-sa-bqjobs-role" {
  project = data.google_project.project.name
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.grafana-service-account.email}"
}

resource "vault_generic_secret" "grafana-sa-key-secret" {
  path      = "secret/dsde/datarepo/${var.env}/grafana-sa-${var.suffix}.json"
  data_json = base64decode(google_service_account_key.grafana-sa-key.private_key)
}
