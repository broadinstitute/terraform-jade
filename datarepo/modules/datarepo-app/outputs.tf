#
# Service Account Outputs
#

#
# CloudSQL PostgreSQL Outputs
#

output "cloudsql_public_ip" {
  value = module.cloudsql.public_ip != "" ? module.cloudsql.public_ip : null
}

output "cloudsql_instance_name" {
  value = module.cloudsql.instance_name != "" ? module.cloudsql.instance_name : null
}

output "cloudsql_root_user_password" {
  value     = module.cloudsql.root_user_password != "" ? module.cloudsql.root_user_password : null
  sensitive = true
}

output "cloudsql_app_db_creds" {
  # Avoiding error on destroy with below condition
  value     = var.enable ? (length(module.cloudsql.app_db_creds) == 0 ? {} : module.cloudsql.app_db_creds[local.service]) : null
  sensitive = true
}

output "cloudsql_app_stairway_db_creds" {
  value     = var.enable ? (length(module.cloudsql.app_db_creds) == 0 ? {} : module.cloudsql.app_db_creds["${local.service}-stairway"]) : null
  sensitive = true
}
