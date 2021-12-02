resource "google_logging_project_bucket_config" "basic" {
  project    = var.google_project
  location  = "global"
  retention_days = var.log_retention_days
  bucket_id = "_Default"
}