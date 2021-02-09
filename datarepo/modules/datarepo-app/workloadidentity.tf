# workload identity GSA to KSA binding, this is a 1:1 so 1 GSA to KSA
module "sql_workloadid" {
  source = "github.com/broadinstitute/terraform-jade.git//datarepo/modules/workloadidentity?ref=master"
  providers = {
    google.target      = google.target
    google-beta.target = google-beta.target
  }

  google_project = var.google_project
  namespace      = var.datarepo_namespace
  gsa_name       = "${var.service}-${local.owner}-sqlproxy"
  ksa_name       = var.sql_ksa_name
  roles          = ["roles/cloudsql.client"]
}
