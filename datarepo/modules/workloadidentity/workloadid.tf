# workload identity GSA to KSA binding, this is a 1:1 so 1 GSA to KSA

resource "google_service_account" "service-account" {
  provider     = google.target
  account_id   = var.gsa_name
  display_name = var.gsa_name
  depends_on   = [var.dependencies]
}

resource "google_service_account_key" "service-account-key" {
  provider           = google.target
  service_account_id = google_service_account.service-account.name
  depends_on         = [var.dependencies, google_service_account.service-account]
}

resource "google_project_iam_member" "service-account-role" {
  for_each   = toset(var.roles)
  provider   = google.target
  project    = var.google_project
  role       = each.key
  member     = "serviceAccount:${google_service_account.service-account.email}"
  depends_on = [var.dependencies, google_service_account.service-account]
}

resource "google_service_account_iam_binding" "workload-identity-binding" {
  provider           = google.target
  service_account_id = google_service_account.service-account.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.google_project}.svc.id.goog[${var.namespace}/${var.ksa_name}]"]
  depends_on         = [var.dependencies, google_service_account.service-account]
}
