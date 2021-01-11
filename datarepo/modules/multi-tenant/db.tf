resource "google_sql_database" "datarepo-db" {
  for_each  = toset(var.db_names)
  provider  = google.target
  name      = "datarepo-${each.key}"
  project   = var.google_project
  instance  = var.sql_server_name
  charset   = "UTF8"
  collation = "en_US.UTF8"
}

resource "google_sql_database" "stairway-db" {
  for_each  = toset(var.db_names)
  provider  = google.target
  name      = "stairway-${each.key}"
  project   = var.google_project
  instance  = var.sql_server_name
  charset   = "UTF8"
  collation = "en_US.UTF8"
}
