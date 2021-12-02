## core-infrastructure vars
variable "google_project" {
  type        = string
  description = "The google project being deployed to"
  default     = ""
}

variable "node_regions" {
  type = map(object({ region = string }))
  default = {
    jade-node-us-central-1 = {
      region = "us-central1"
    }
  }
}

variable "datarepo_namespace" {
  type        = string
  description = "kubernetes namespace"
}

variable "sql_ksa_name" {
  type        = string
  description = "kubernetes service ccount for sql"
}

variable "k8_network_name" {
  description = "core network name to be deployed and put k8 cluster on"
  default     = ""
}

variable "k8_subnet_name" {
  description = "name of gcp the subnet"
  default     = ""
}

variable "node_count" {
  type        = number
  description = "number of kubernetes nodes depends on if region is us-central1 1 will deploy 3 and us-central1-a 3 will deploy 3"
  default     = "1"
}

variable "machine_type" {
  type        = string
  description = "type of machine used for kubernetes"
  default     = "n1-standard-2"
}

variable "region" {
  description = "GCP region being used"
  default     = "us-central1"
}

variable "version_prefix" {
  type        = string
  default     = "1.17.14-gke.400"
  description = "version of gke to be deployed"
}

variable "enable_flow_logs" {
  type        = bool
  default     = false
  description = "flag for enabling flowlog"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain service logs"
  default     = "30"
}

## datarepo-app vars

variable "cloudsql_tier" {
  type        = string
  description = "Custom tier (DB instance size) for CloudSQL instances"
  default     = "db-custom-2-7680"
}

variable "dns_name" {
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

variable "environment" {
  type        = string
  description = "environment being deployed"
  default     = ""
}

variable "dns_zone" {
  type        = string
  description = "global DNS zone to be deployed"
  default     = ""
}

locals {
  workloadid_names = [var.environment]
}

variable "enable_private_services" {
  type        = bool
  description = "Enable flag for a private sql instance if set to true, a private sql isntance will be created."
  default     = true
}

variable "ip_only" {
  type        = bool
  description = "Enable flag for only create a global static ip vs ip and dns"
  default     = false
}

variable "argocd_cidrs" {
  type        = list(any)
  description = "argocd broad external ips to be added to the master auth network"
  default     = []
}

variable "token_secret_path" {
  type        = string
  description = "The vault path for the slack token"
  default     = "secret/suitable/terraform/stackdriver/slack-token"
}

variable "host" {
  type        = string
  description = "The host end point on the internet"
  default     = ""
}

variable "monitoring_namespace" {
  type        = string
  default     = "monitoring"
  description = "kubernetes namespace"
}

variable "gsa_name" {
  type        = string
  description = "google service account for workloadid binding"
  default     = ""
}

variable "ksa_name" {
  type        = string
  description = "kubernetes service account for workloadid binding"
  default     = ""
}

variable "roles" {
  type        = list(string)
  default     = ["roles/monitoring.admin", "roles/logging.admin", "roles/monitoring.metricWriter"]
  description = "List of google roles to apply to service account"
}

## production monitoring
variable "enable_bigquery" {
  default = false
  type    = bool
}

variable "enable_gcs" {
  default = false
  type    = bool
}

variable "enable_pubsub" {
  default = false
  type    = bool
}

variable "enable_monitoring" {
  default = false
  type    = bool
}

variable "external_folder_ids" {
  type        = list(string)
  description = "Folder ids used by RBS"
  default     = []
}
