## api sa
resource "google_service_account" "datarepo_api_sa" {
  count        = var.enable ? 1 : 0
  provider     = google-beta.target
  project      = var.google_project
  account_id   = "${var.service}-${local.owner}-api"
  display_name = "${var.service}-${local.owner}-api"
}

resource "google_project_iam_member" "api_sa_role" {
  count = var.enable ? length(local.api_sa_roles) : 0

  provider = google.target
  project  = var.google_project
  role     = local.api_sa_roles[count.index]
  member   = "serviceAccount:${google_service_account.datarepo_api_sa[0].email}"
}

resource "google_folder_iam_member" "app_folder_roles" {
  // Skip if folder_ids_and_roles variable is not present.
  count = var.enable ? length(local.folder_ids_and_roles) : 0

  provider = google.target
  folder   = local.folder_ids_and_roles[count.index].folder_id
  role     = local.folder_ids_and_roles[count.index].folder_role
  member   = "serviceAccount:${google_service_account.datarepo_api_sa[0].email}"
}

##
# vault write api
resource "google_service_account_key" "api_sa_key" {
  count = var.enable ? 1 : 0

  provider           = google.target
  service_account_id = google_service_account.datarepo_api_sa[0].name
}

resource "vault_generic_secret" "api_sa_key" {
  count = var.enable ? 1 : 0

  provider = vault.target
  path     = "${local.vault_path}/datarepo-api-sa"

  data_json = <<EOT
{
  "key": "${google_service_account_key.api_sa_key[0].private_key}"
}
EOT

  lifecycle {
    ignore_changes = [data_json] # Ignore changes since this key is automatically rotated
  }
}

## test-runner-sa
resource "google_service_account" "datarepo_test_runner_sa" {
  count        = (var.enable && !local.is_production) ? 1 : 0
  provider     = google.target
  project      = var.google_project
  account_id   = "${var.service}-${local.owner}-test-runner"
  display_name = "${var.service}-${local.owner}-test-runner"
}

resource "google_project_iam_member" "test_runner_sa_role" {
  count = (var.enable && !local.is_production) ? length(local.test_runner_roles) : 0

  provider = google.target
  project  = var.google_project
  role     = local.test_runner_roles[count.index]
  member   = "serviceAccount:${google_service_account.datarepo_test_runner_sa[0].email}"
}

## vault write test-runner-sa
resource "google_service_account_key" "test_runner_sa_key" {
  count = (var.enable && !local.is_production) ? 1 : 0

  provider           = google.target
  service_account_id = google_service_account.datarepo_test_runner_sa[0].name
}

resource "vault_generic_secret" "test_runner_sa_key" {
  count = (var.enable && !local.is_production) ? 1 : 0

  provider = vault.target
  path     = "${local.vault_path}/test-runner-sa"

  data_json = <<EOT
{
  "key": "${google_service_account_key.test_runner_sa_key[0].private_key}"
}
EOT
}
