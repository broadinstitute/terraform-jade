module "vault-log-sinks" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=sinks-0.0.8-tf-0.12"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers = {
    google = google
  }

  /*
  * REQUIRED VARIABLES
  */
  enable_gcs      = var.audit_enable_gcs
  enable_bigquery = var.audit_enable_bigquery


  # The name of the person or team responsible for the lifecycle of this infrastructure
  owner = "jade"

  # The name of the application
  application_name = "datarepo"

  log_filter = "resource.type=\"audited_resource\""

  # Name of the google project
  project = data.google_project.project.name

  bigquery_retention_days = 60
}

module "lb-log-sinks" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=sinks-0.0.8-tf-0.12"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers = {
    google = google
  }

  /*
  * REQUIRED VARIABLES
  */
  enable_pubsub   = var.load_balancer_enable_pubsub
  enable_bigquery = var.load_balancer_enable_bigquery

  # The name of the person or team responsible for the lifecycle of this infrastructure
  owner = "jade"

  # The name of the application
  application_name = "datarepo"

  log_filter = "resource.type=\"http_load_balancer\""

  # Name of the google project
  project = data.google_project.project.name

}

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
