
module "cloudsql" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-postgres?ref=fb-dr-1502-pg-max-connections"

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
  postgres_max_connections  = var.postgres_max_connections
  private_enable            = var.enable_private_db
  private_network_self_link = var.private_network_self_link
  enable_private_services   = var.enable_private_services
  existing_vpc_network      = var.existing_vpc_network

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

resource "vault_generic_secret" "sql_db_password" {
  count = var.enable ? 1 : 0

  depends_on = [var.dependencies]
  provider   = vault.target
  path       = "${local.vault_path}/datarepo-sql-db"

  data_json = <<EOT
{
  "datarepouser": "${module.cloudsql.app_db_creds["${local.service}"].username}",
  "datarepopassword": "${module.cloudsql.app_db_creds["${local.service}"].password}",
  "stairwayuser": "${module.cloudsql.app_db_creds["${local.service}-stairway"].username}",
  "stairwaypassword": "${module.cloudsql.app_db_creds["${local.service}-stairway"].password}"
}
EOT
}
