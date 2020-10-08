## core-infrastructure vars
variable "google_project" {
  type        = string
  description = "The google project being deployed to"
  default     = "broad-jade-perf"
}

variable "k8_network_name" {
  default     = "perf-network"
  description = "core network name to be deployed and put k8 cluster on"
}

variable "k8_subnet_name" {
  description = "name of the subnet within the networking being deployed"
  default     = "perf-subnet"
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
  default     = "1.16.13-gke.401"
  description = "version of gke to be deployed"
}

## datarepo-app vars

variable dns_name {
  type        = string
  description = "List of DNS names to generate global IP addresses, A-records, and CNAME-records for."
  default     = "jade-perf"
}

variable "db_version" {
  type        = string
  description = "Postgres db verion"
  default     = "POSTGRES_11"
}

variable "environment" {
  type        = string
  description = "environment being deployed"
  default     = "perf"
}

variable "dns_zone" {
  type        = string
  description = "global DNS zone to be deployed"
  default     = "datarepo-perf"
}

locals {
  workloadid_names = [var.environment]
}

variable "enable_private_services" {
  type        = bool
  description = "Enable flag for a private sql instance if set to true, a private sql isntance will be created."
  default     = true
}

variable "argocd_cidrs" {
  type        = list
  description = "argocd broad external ips to be added to the master auth network"
  default     = ["35.202.125.180/32", "34.70.76.7/32"]
}

variable "token_secret_path" {
  type        = string
  description = "The vault path for the slack token"
  default     = "secret/suitable/terraform/stackdriver/slack-token"
}

variable "host" {
  type        = string
  description = "The host end point on the internet"
  default     = "jade-perf.datarepo-perf.broadinstitute.org"
}

variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "kubernetes namespace"
}

variable "gsa_name" {
  type        = string
  default     = "prometheus-sa"
  description = "google service account for workloadid binding"
}

variable "ksa_name" {
  type        = string
  default     = "datarepo-monitoring-kube-p-prometheus"
  description = "kubernetes service account for workloadid binding"
}

variable "roles" {
  type        = list(string)
  default     = ["roles/monitoring.admin", "roles/logging.admin", "roles/monitoring.metricWriter"]
  description = "List of google roles to apply to service account"
}

variable "db_tier" {
  type        = string
  default     = "db-custom-16-32768" # match sam postgres in prod
  description = "Custom tier (DB instance size) for CloudSQL instances"
}
