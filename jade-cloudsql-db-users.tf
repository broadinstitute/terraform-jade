resource "google_sql_database" "jade-datarepo-db" {
  name       = "datarepo"
  project    = var.project
  instance   = google_sql_database_instance.jade_100_postgres[0].name
  charset    = "UTF8"
  collation  = "en_US.UTF8"
  depends_on = [google_sql_database_instance.jade_100_postgres]
}

resource "google_sql_database" "jade-stairway-db" {
  name       = "stairway"
  project    = var.project
  instance   = google_sql_database_instance.jade_100_postgres[0].name
  charset    = "UTF8"
  collation  = "en_US.UTF8"
  depends_on = [google_sql_database_instance.jade_100_postgres]
}

resource "google_sql_user" "jade-db-user" {
  name       = "drmanager"
  password   = random_id.jade-db-password.hex
  project    = var.project
  instance   = google_sql_database_instance.jade_100_postgres[0].name
  depends_on = [google_sql_database_instance.jade_100_postgres]
}

resource "random_id" "jade-db-password" {
  byte_length = 16
  depends_on  = [google_sql_database_instance.jade_100_postgres]
}
####
resource "google_sql_database" "jade-datarepo-db-11" {
  name       = "datarepo"
  project    = var.project
  instance   = google_sql_database_instance.jade_11_postgres_db[0].name
  charset    = "UTF8"
  collation  = "en_US.UTF8"
  depends_on = [google_sql_database_instance.jade_11_postgres_db]
}

resource "google_sql_database" "jade-stairway-db-11" {
  name       = "stairway"
  project    = var.project
  instance   = google_sql_database_instance.jade_11_postgres_db[0].name
  charset    = "UTF8"
  collation  = "en_US.UTF8"
  depends_on = [google_sql_database_instance.jade_11_postgres_db]
}

resource "google_sql_user" "jade-db-user-11" {
  name       = "drmanager"
  password   = random_id.jade-db-password.hex
  project    = var.project
  instance   = google_sql_database_instance.jade_11_postgres_db[0].name
  depends_on = [google_sql_database_instance.jade_11_postgres_db]
}
