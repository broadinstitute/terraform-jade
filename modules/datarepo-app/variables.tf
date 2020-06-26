#
# General Vars
#
variable "dependencies" {
  # See: https://github.com/hashicorp/terraform/issues/21418#issuecomment-495818852
  type        = any
  default     = []
  description = "Work-around for Terraform 0.12's lack of support for 'depends_on' in custom modules."
}

variable "enable" {
  type        = bool
  description = "Enable flag for this module. If set to false, no resources will be created."
  default     = true
}

variable "google_project" {
  type        = string
  description = "The google project"
}

variable "owner" {
  type        = string
  description = " or developer"
  default     = "jade"
}

locals {
  owner   = var.owner == "" ? terraform.workspace : var.owner
  service = "datarepo"
}


#
# Service Account Vars
#
locals {
  sql_sa_roles = [
    "roles/cloudsql.client"
  ]
}

locals {
  api_sa_roles = [
    "roles/bigquery.admin",
    "roles/cloudsql.admin",
    "roles/datastore.user",
    "roles/errorreporting.writer",
    "roles/logging.logWriter",
    "roles/monitoring.admin",
    "roles/servicemanagement.serviceController",
    "roles/stackdriver.accounts.viewer",
    "roles/storage.admin",
    "roles/pubsub.admin"
  ]
}


#
# Postgres CloudSQL DB Vars
#
variable "db_tier" {
  type        = string
  default     = "db-g1-small"
  description = "The default tier (DB instance size) for the CloudSQL instance"
}

variable "db_name" {
  type        = string
  description = "Postgres db name"
  default     = "datarepo"
}

variable "db_user" {
  type        = string
  description = "Postgres username"
  default     = "drmanager"
}

variable "stairway_db_name" {
  type        = string
  description = "Stairway db name"
  default     = "stairway"
}

locals {
  db_name          = var.db_name == "" ? local.service : var.db_name
  db_user          = var.db_user == "" ? local.service : var.db_user
  stairway_db_name = var.stairway_db_name == "" ? "${local.service}-stairway" : var.stairway_db_name
  stairway_db_user = var.db_user == "" ? "${local.service}-stairway" : var.db_user
}
## new
variable dns_zone {
  type        = string
  default     = ""
  description = "The name of managed dns zone to put cname and a record in"
}

variable dns_names {
  type        = list(string)
  description = "List of DNS names to generate global IP addresses, A-records, and CNAME-records for."
}

variable "db_version" {
  type        = string
  description = "Postgres db verion"
  default     = "POSTGRES_11"
}

variable "enable_private_db" {
  type        = bool
  description = "Postgres db name"
  default     = true
}

variable "environment" {
  description = "environment being deployed"
  default     = ""
  type        = string
}


locals {
  vault_root = "secret/dsde/datarepo/${var.environment}"
}

variable "private_network" {
  type        = string
  description = "network sql server is being deployed to"
  default     = ""
}

variable "private_network_self_link" {
  type        = string
  default     = null
  description = "Name of the projects network that the NAT/VPC pairing sql ip will be put on."
}

variable "enable_workloadid" {
  type        = bool
  description = "enable workloadIdentityUser"
  default     = false
}

variable "workloadid_names" {
  type        = list(string)
  description = "List of DNS names to generate global IP addresses, A-records, and CNAME-records for."
}

variable "enable_private_services" {
  type = bool
  description = "Enable flag for a private sql instance if set to true, a private sql isntance will be created."
  default = false
}
