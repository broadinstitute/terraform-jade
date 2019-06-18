resource "google_sql_database" "jade-datarepo-db" {
    name = "datarepo"
    project = "${var.project}"
    instance = "${google_sql_database_instance.jade_100_postgres.name}"
    charset = "UTF8"
    collation = "en_US.UTF8"
}

resource "google_sql_database" "jade-stairway-db" {
    name = "stairway"
    project = "${var.project}"
    instance = "${google_sql_database_instance.jade_100_postgres.name}"
    charset = "UTF8"
    collation = "en_US.UTF8"
}
