resource "google_sql_database" "jade-datarepo-db" {
    name        = "datarepo"
    project     = var.project
    instance    = google_sql_database_instance.jade_100_postgres[0].name
    charset     = "UTF8"
    collation   = "en_US.UTF8"
    depends_on  = [google_sql_database_instance.jade_100_postgres]
}

resource "google_sql_database" "jade-stairway-db" {
    name        = "stairway"
    project     = var.project
    instance    = google_sql_database_instance.jade_100_postgres[0].name
    charset     = "UTF8"
    collation   = "en_US.UTF8"
    depends_on  = [google_sql_database_instance.jade_100_postgres]
}

resource "random_id" "jade-db-password" {
    byte_length = 16
    depends_on  = [google_sql_database_instance.jade_100_postgres]
}

resource "google_sql_user" "jade-db-user" {
    name        = "drmanager"
    password    =  random_id.jade-db-password.hex
    project     = var.project
    instance    = google_sql_database_instance.jade_100_postgres[0].name
    depends_on  = [google_sql_database_instance.jade_100_postgres]
}

resource "vault_generic_secret" "jade-db-login-secret" {
    path      = "secret/dsde/datarepo/${var.env}/api-secrets-${var.suffix}.json"
    data_json = <<EOT
{
  "datarepoPassword": "${google_sql_user.jade-db-user.password}",
  "datarepoUsername": "${google_sql_user.jade-db-user.name}",
  "stairwayPassword": "${google_sql_user.jade-db-user.password}",
  "stairwayUsername": "${google_sql_user.jade-db-user.name}",
  "instanceName": "${google_sql_database_instance.jade_100_postgres[0].name}",
  "connectionName": "${google_sql_database_instance.jade_100_postgres[0].connection_name}",
  "ip": "${google_sql_database_instance.jade_100_postgres[0].ip_address.0.ip_address}",
  "springProfilesActive": "google,cloudsql,${var.suffix}"
}
EOT
}