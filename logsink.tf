module "vault-log-sinks" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=ms-pubsub"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers = {
    google = google
  }

  /*
  * REQUIRED VARIABLES
  */
  enable_gcs      = var.enable_gcs
  enable_bigquery = var.enable_bigquery


  # The name of the person or team responsible for the lifecycle of this infrastructure
  owner = "jade-data-repo"

  # The name of the application
  application_name = "jade"

  log_filter = "resource.type=\"audited_resource\""

  # Name of the google project
  project = var.env_project

  bigquery_retention_days = 60
}

module "lb-log-sinks" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=ms-pubsub"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers = {
    google = google
  }

  /*
  * REQUIRED VARIABLES
  */
  enable_pubsub = var.enable_pubsub


  # The name of the person or team responsible for the lifecycle of this infrastructure
  owner = "jade-data-repo"

  # The name of the application
  application_name = "jade"

  log_filter = "resource.type=\"http_load_balancer\""

  # Name of the google project
  project = var.env_project

}
