
module "cloudsql" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-postgres?ref=ms-postgres-fix"

  enable       = var.enable
  dependencies = var.dependencies
  providers = {
    google.target = google-beta.target
  }
  project       = var.google_project
  cloudsql_name = "${local.service}-db-${local.owner}"
  cloudsql_instance_labels = {
    "env" = local.owner
    "app" = local.service
  }
  cloudsql_tier             = var.db_tier
  cloudsql_version          = var.db_version
  private_enable            = var.enable_private_db
  private_network_self_link = var.private_network_self_link
  enable_private_services   = var.enable_private_services

  app_dbs = {
    "${local.service}" = {
      db       = local.db_name
      username = local.db_user
    }
    "${local.service}-stairway" = {
      db       = local.stairway_db_name
      username = local.stairway_db_user
    }
  }
}
