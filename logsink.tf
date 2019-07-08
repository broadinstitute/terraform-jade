module "vault-log-sinks" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=gcs_bq_log_sink-0.0.2"

  # Alias of the provider you want to use--the provider's project controls the resource project
  providers {
    google = "google"
  }

  /*
  * REQUIRED VARIABLES
  */
  enable_gcs = 1
  enable_bigquery = 1

  # The name of the person or team responsible for the lifecycle of this infrastructure
  owner = "jade-data-repo"

  # The name of the application
  application_name = "jade"

  log_filter = "resource.type=\"cloudsql_database\""
  # Name of the google project
  project = "${var.env_project}"

  bigquery_retention_days = 60

}
