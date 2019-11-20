resource "google_bigquery_dataset" "dataset" {
  dataset_id = "user_api_activity"
  location = "us-east4"
}

resource "google_logging_project_sink" "user-activity-sink" {
  name = "user-api-activity"
  destination = "bigquery.googleapis.com/projects/${var.project}/datasets/user_api_activity"
  filter = "resource.type=\"container\" \"LoggerInterceptor\""
}
