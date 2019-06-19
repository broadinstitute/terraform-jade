resource "google_sql_database" "jade-datarepo-db" {
    name = "datarepo"
    project = "${var.project}"
    instance = "${google_sql_database_instance.jade_100_postgres.name}"
    charset = "UTF8"
    collation = "en_US.UTF8"
    depends_on = ["google_sql_database_instance.jade_100_postgres"]
}

resource "google_sql_database" "jade-stairway-db" {
    name = "stairway"
    project = "${var.project}"
    instance = "${google_sql_database_instance.jade_100_postgres.name}"
    charset = "UTF8"
    collation = "en_US.UTF8"
    depends_on = ["google_sql_database_instance.jade_100_postgres"]
}

resource "random_id" "jade-db-password" {
    byte_length = 16
    depends_on = ["google_sql_database_instance.jade_100_postgres"]
}

resource "google_sql_user" "jade-db-user" {
    name = "drmanager"
    password =  "${random_id.jade-db-password.hex}"
    project = "${var.project}"
    instance = "${google_sql_database_instance.jade_100_postgres.name}"
    depends_on = ["google_sql_database_instance.jade_100_postgres"]
}

resource "vault_generic_secret" "jade-db-login-secret" {
    path = "secret/dsde/datarepo/dev/db-secrets.json"
    data_json = <<EOT
{
  "cloud_sql_proxy":{
      "instance_name": "${google_sql_database_instance.jade_100_postgres.name}",
      "connection_name": "${google_sql_database_instance.jade_100_postgres.connection_name}"
  },
  "datarepo":{
    "db_name": "${google_sql_database.jade-datarepo-db.name}",
    "username": "${google_sql_user.jade-db-user.name}",
    "password": "${google_sql_user.jade-db-user.password}"
  },
  "stairway":{
    "db_name": "${google_sql_database.jade-stairway-db.name}",
    "username": "${google_sql_user.jade-db-user.name}",
    "password": "${google_sql_user.jade-db-user.password}"
    }
}
EOT
}
