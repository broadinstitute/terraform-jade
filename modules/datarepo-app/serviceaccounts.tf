## sql sa
resource "google_service_account" "datarepo_sql_sa" {
  count        = var.enable ? 1 : 0
  provider     = google.target
  project      = var.google_project
  account_id   = "${local.service}-${local.owner}-sql"
  display_name = "${local.service}-${local.owner}-sql"
  depends_on   = [var.dependencies]
}

resource "google_project_iam_member" "sql_sa_role" {
  count = var.enable ? length(local.sql_sa_roles) : 0

  provider   = google.target
  project    = var.google_project
  role       = local.sql_sa_roles[count.index]
  member     = "serviceAccount:${google_service_account.datarepo_sql_sa[0].email}"
  depends_on = [var.dependencies]
}

## vault write sql
resource "google_service_account_key" "sql_sa_key" {
  count = var.enable ? 1 : 0

  provider           = google.target
  service_account_id = google_service_account.datarepo_sql_sa[0].name
  depends_on         = [var.dependencies]
}

resource "vault_generic_secret" "sql_sa_key" {
  count = var.enable ? 1 : 0

  depends_on = [var.dependencies]
  provider   = vault.target
  path       = "${local.vault_root}/datarepo-sql-sa"

  data_json = <<EOT
{
  "key": "${google_service_account_key.sql_sa_key[0].private_key}"
}
EOT
}

## api sa
resource "google_service_account" "datarepo_api_sa" {
  count        = var.enable ? 1 : 0
  provider     = google-beta.target
  project      = var.google_project
  account_id   = "${local.service}-${local.owner}-api"
  display_name = "${local.service}-${local.owner}-api"
  depends_on   = [var.dependencies]
}

resource "google_project_iam_member" "api_sa_role" {
  count = var.enable ? length(local.api_sa_roles) : 0

  provider   = google.target
  project    = var.google_project
  role       = local.api_sa_roles[count.index]
  member     = "serviceAccount:${google_service_account.datarepo_api_sa[0].email}"
  depends_on = [var.dependencies]
}

##
# vault write api
resource "google_service_account_key" "api_sa_key" {
  count = var.enable ? 1 : 0

  provider           = google.target
  service_account_id = google_service_account.datarepo_api_sa[0].name
  depends_on         = [var.dependencies]
}

resource "vault_generic_secret" "api_sa_key" {
  count = var.enable ? 1 : 0

  depends_on = [var.dependencies]
  provider   = vault.target
  path       = "${local.vault_root}/datarepo-api-sa"

  data_json = <<EOT
{
  "key": "${google_service_account_key.api_sa_key[0].private_key}"
}
EOT
}
