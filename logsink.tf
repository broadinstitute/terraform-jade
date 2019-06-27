module "vault-log-sinks" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/gcs_bq_log_sink?ref=ms-sink-permissions"

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
  owner = "jhert"

  # The name of the application
  application_name = "jade"

  log_filter = "resource.type=(\"container\" OR \"cloudsql_database\" OR \"http_load_balancer\" OR \"k8s_cluster\")"
  # Name of the google project
  project = "${var.env_project}"

}
