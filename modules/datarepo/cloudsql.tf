
#  Gcp Sql Postgres 11
module datarepo_psql {
  # terraform-shared repo
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-postgres?ref=cloudsql-postgres-1.1.1"

  enable = var.enable

  providers = {
    google.target = google-beta.datarepo-dns
  }

  project                       = var.google_project
  cloudsql_name                 = "${local.service}-db-${local.owner}"
  cloudsql_instance_labels = {
    "env" = local.owner
    "app" = local.service
  }
  cloudsql_tier = var.db_tier

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
  cloudsql_version              = var.db_version
  private_enable                = var.enable_private_db
  private_network               = var.network
  app_dbs                       = var.app_dbs
  dependencies                  = [ var.dependencies ]
}
