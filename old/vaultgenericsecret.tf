resource "vault_generic_secret" "sql-backup-key-secret" {
  path      = "secret/dsde/datarepo/${var.env}/sql-backup-${var.suffix}-b64"
  data_json = <<EOT
{
"sa": "${google_service_account_key.sql-backup-key.private_key}"
}
EOT
}

resource "vault_generic_secret" "sql-sa-key-secret" {
  path = "secret/dsde/datarepo/${var.env}/sqlproxy-sa-${var.suffix}-b64"
  #    data_json = base64decode(google_service_account_key.sql-sa-key.private_key)
  data_json = <<EOT
{
    "sa": "${google_service_account_key.sql-sa-key.private_key}"
}
EOT
}

resource "vault_generic_secret" "jade-db-login-secret" {
  path      = "secret/dsde/datarepo/${var.env}/helm-datarepodb-${var.suffix}"
  data_json = <<EOT
{
  "datarepousername": "${google_sql_user.jade-db-user.name}",
  "datarepopassword": "${google_sql_user.jade-db-user.password}",
  "stairwayusername": "${google_sql_user.jade-db-user.name}",
  "stairwaypassword": "${google_sql_user.jade-db-user.password}"
}
EOT
}
