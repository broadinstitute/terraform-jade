module "audit-log-sinks" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=sinks-0.0.10"

  providers = {
    google.target      = google.target
    google-beta.target = google-beta.target
  }

  dependencies            = var.dependencies
  enable_bigquery         = var.enable_bigquery
  enable_gcs              = var.enable_gcs
  owner                   = var.environment
  application_name        = var.application_name
  log_filter              = "resource.type=\"audited_resource\""
  project                 = var.google_project
  bigquery_retention_days = var.bigquery_retention_days

}

module "user-activity-sinks" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=sinks-0.0.10"

  providers = {
    google.target      = google.target
    google-beta.target = google-beta.target
  }

  dependencies     = var.dependencies
  enable_pubsub    = 0
  enable_bigquery  = var.enable_bigquery
  owner            = var.environment
  application_name = var.application_name
  log_filter       = "resource.type=\"k8s_container\" \"LoggerInterceptor\""
  project          = var.google_project

}

module "performance-log-sinks" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=sinks-0.0.10"

  providers = {
    google.target      = google.target
    google-beta.target = google-beta.target
  }

  dependencies     = var.dependencies
  enable_pubsub    = 0
  enable_bigquery  = var.enable_bigquery
  owner            = var.environment
  application_name = var.application_name
  log_filter       = "resource.type=\"k8s_container\" \"PerformanceLogger\""
  project          = var.google_project

}

resource "google_bigquery_table" "logs" {
  count      = var.enable ? 1 : 0
  provider   = google-beta.target
  dataset_id = module.user-activity-sinks.dataset_id[0]
  table_id   = "all_user_requests"
  depends_on = [var.dependencies, module.user-activity-sinks]
  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = var.google_project
  }

  view {
    query          = <<EOF
SELECT timestamp,
  REGEXP_EXTRACT(textPayload, r"userId: ([^,]+)") AS user_id,
  REGEXP_EXTRACT(textPayload, r"email: ([^,]+)") AS email,
  REGEXP_EXTRACT(textPayload, r"status: ([^,]+)") AS status,
  REGEXP_EXTRACT(textPayload, r"method: ([^,]+)") AS method,
  REGEXP_EXTRACT(textPayload, r"url: ([^,]+)") AS url
FROM `${var.google_project}.${module.user-activity-sinks.dataset_id[0]}.stdout_*`;
EOF
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "performance_logs" {
  count      = var.enable ? 1 : 0
  provider   = google-beta.target
  dataset_id = module.performance-log-sinks.dataset_id[0]
  table_id   = "performance_logs"
  depends_on = [var.dependencies, module.performance-log-sinks]

  labels = {
    env = var.google_project
  }

  view {
    query          = <<EOF
SELECT timestamp,
  REGEXP_EXTRACT(textPayload, r"TimestampUTC: ([^,]+)") AS TimestampUTC,
  REGEXP_EXTRACT(textPayload, r"JobId: ([^,]+)") AS JobId,
  REGEXP_EXTRACT(textPayload, r"Class: ([^,]+)") AS Class,
  REGEXP_EXTRACT(textPayload, r"Operation: ([^,]+)") AS Operation,
  REGEXP_EXTRACT(textPayload, r"ElapsedTime: ([^,]+)") AS ElapsedTime,
  REGEXP_EXTRACT(textPayload, r"IntegerCount: ([^,]+)") AS IntegerCount,
  REGEXP_EXTRACT(textPayload, r"AdditionalInfo: ([^,]+)") AS AdditionalInfo
FROM `${var.google_project}.${module.performance-log-sinks.dataset_id[0]}.stdout_*`;
EOF
    use_legacy_sql = false
  }
}
