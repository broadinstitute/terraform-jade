
module "cloudsql" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-postgres?ref=cloudsql-postgres-1.2.3"

  enable = var.enable
  providers = {
    google.target = google-beta.target
  }
  project       = var.google_project
  cloudsql_name = "${var.service}-db-${local.owner}"
  cloudsql_instance_labels = {
    "env" = local.owner
    "app" = var.service
  }
  cloudsql_tier             = var.cloudsql_tier
  cloudsql_version          = var.db_version
  postgres_max_connections  = var.postgres_max_connections
  private_enable            = var.enable_private_db
  private_network_self_link = var.private_network_self_link
  enable_private_services   = var.enable_private_services
  existing_vpc_network      = var.existing_vpc_network

  app_dbs = {
    datarepo = {
      db       = local.db_name
      username = local.db_user
    }
    "${var.service}-stairway" = {
      db       = local.stairway_db_name
      username = local.stairway_db_user
    }
  }
}

resource "vault_generic_secret" "sql_db_password" {
  count = var.enable ? 1 : 0

  provider = vault.target
  path     = "${local.vault_path}/datarepo-sql-db"

  data_json = <<EOT
{
  "datarepouser": "${module.cloudsql.app_db_creds["${var.service}"].username}",
  "datarepopassword": "${module.cloudsql.app_db_creds["${var.service}"].password}",
  "stairwayuser": "${module.cloudsql.app_db_creds["${var.service}-stairway"].username}",
  "stairwaypassword": "${module.cloudsql.app_db_creds["${var.service}-stairway"].password}"
}
EOT
}
