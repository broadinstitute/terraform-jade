
module "user-activity-sinks" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=sinks-0.0.9"

  providers = {
    google = google
  }

  enable_pubsub    = var.user_activity_enable_pubsub
  enable_bigquery  = var.user_activity_enable_bigquery
  owner            = "jade"
  application_name = "datarepo"
  log_filter       = "resource.type=\"k8s_container\" \"LoggerInterceptor\""
  project          = data.google_project.project.name

}

module "performance-log-sinks" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=sinks-0.0.9"

  providers = {
    google.target      = google
    google-beta.target = google-beta
  }

  enable_pubsub    = 0
  enable_bigquery  = 1
  owner            = "jade"
  application_name = "datarepo"
  log_filter       = "resource.type=\"k8s_container\" \"PerformanceLogger\""
  project          = data.google_project.project.name

}
