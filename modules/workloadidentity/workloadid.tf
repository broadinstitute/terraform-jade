# workload identity GSA to KSA binding, this is a 1:1 so 1 GSA to KSA

resource "google_service_account" "user-sql-service-account" {
  for_each     = toset(var.workloadid_names)
  provider     = google.target
  account_id   = "${each.key}-workload-proxy-sa"
  display_name = "${each.key}-workload-proxy-sa"
  depends_on   = [var.dependencies]
}

resource "google_service_account_key" "user-sql-sa-key" {
  for_each           = toset(var.workloadid_names)
  provider           = google.target
  service_account_id = google_service_account.user-sql-service-account[each.key].name
  depends_on         = [var.dependencies, google_service_account.user-sql-service-account]
}

resource "google_project_iam_member" "user-sql-sa-role" {
  for_each   = toset(var.workloadid_names)
  provider   = google.target
  project    = var.google_project
  role       = "roles/cloudsql.client"
  member     = "serviceAccount:${google_service_account.user-sql-service-account[each.key].email}"
  depends_on = [var.dependencies, google_service_account.user-sql-service-account]
}

resource "google_service_account_iam_binding" "sqlproxy_workload_identity_binding" {
  for_each           = toset(var.workloadid_names)
  provider           = google.target
  service_account_id = google_service_account.user-sql-service-account[each.key].name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.google_project}.svc.id.goog[${each.key}/${each.key}-jade-gcloud-sqlproxy]"]
  depends_on         = [var.dependencies, google_service_account.user-sql-service-account]
}
