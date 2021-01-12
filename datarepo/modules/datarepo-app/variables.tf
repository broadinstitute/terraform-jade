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
  owner = var.owner == "" ? terraform.workspace : var.owner
}

variable "service" {
  type    = string
  default = "datarepo"
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
    "roles/pubsub.admin",
    "roles/container.admin",
    "roles/resourcemanager.projectIamAdmin"
  ]
}

locals {
  test_runner_roles = [
    "roles/container.admin",    # Kubernetes Engine Admin
    "roles/logging.viewer",     # Logs Viewer
    "roles/monitoring.viewer",  # Monitoring Viewer
    "roles/secretmanager.admin" # Secret Manager Admin
  ]
}

#
# Postgres CloudSQL DB Vars
#
variable "cloudsql_tier" {
  type        = string
  default     = "db-custom-2-7680"
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
  db_name          = var.db_name == "" ? var.service : var.db_name
  db_user          = var.db_user == "" ? var.service : var.db_user
  stairway_db_name = var.stairway_db_name == "" ? "${var.service}-stairway" : var.stairway_db_name
  stairway_db_user = var.db_user == "" ? "${var.service}-stairway" : var.db_user
}

variable "existing_vpc_network" {
  type        = string
  default     = null
  description = "Name of the projects network that the NAT/VPC pairing sql ip will be put on."
}
## new
variable dns_zone {
  type        = string
  default     = ""
  description = "The name of managed dns zone to put cname and a record in"
}

variable dns_name {
  type        = string
  description = "List of DNS names to generate global IP addresses, A-records, and CNAME-records for."
  default     = ""
}

variable "db_version" {
  type        = string
  description = "Postgres db verion"
  default     = "POSTGRES_11"
}

variable "postgres_max_connections" {
  type        = number
  description = "Maximum number of concurrent connections to the database server"
  default     = 200
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

variable "vault_root" {
  type        = string
  description = "Path in Vault where secrets should be stored"
  default     = "secret/dsde/datarepo"
}

locals {
  vault_path = "${var.vault_root}/${var.environment}"
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
  description = "Workload identity names"
  default     = []
}

variable "enable_private_services" {
  type        = bool
  description = "Enable flag for a private sql instance if set to true, a private sql isntance will be created."
  default     = false
}

variable "ip_only" {
  type        = bool
  description = "Enable flag for this module. If set to false, no resources will be created."
  default     = false
}
