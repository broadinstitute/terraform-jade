variable "enable" {
  type        = bool
  description = "Enable flag for this module. If set to false, no resources will be created."
  default     = true
}

variable "environment" {
  type        = string
  description = "team environment being deployed"
  default     = "jade"
}

variable "google_project" {
  type        = string
  description = "The google project"
}

variable "host" {
  type        = string
  description = "The host end point on the internet"
}

variable "path" {
  type        = string
  description = "The host end point on the internet sub path"
  default     = "/"
}

variable "slack_channel" {
  type        = string
  description = "The slack channel to report to"
  default     = "#jade-alerts"
}

variable "workbench_alert_name" {
  type        = string
  description = "The workbench alert name"
  default     = "workbench-oncall"
}

variable "workbench_slack_channel" {
  type        = string
  description = "The workbench slack channel to report to"
  default     = "#workbench-oncall"
}

variable "token_secret_path" {
  type        = string
  description = "The vault path for the slack token"
}

variable "ip_only" {
  type        = bool
  description = "Enable flag for this module. If set to false, no resources will be created."
  default     = false
}

variable "monitoring_namespace" {
  type        = string
  description = "kubernetes namespace"
}

variable "gsa_name" {
  type        = string
  description = "google service account for workloadid binding"
}

variable "ksa_name" {
  type        = string
  description = "kubernetes service account for workloadid binding"
}

variable "roles" {
  type        = list(string)
  description = "List of google roles to apply to service account"
}

variable "dns_zone" {
  type        = string
  default     = ""
  description = "dns zone for grafana or prometheus"
}

variable "dns_zone_name" {
  type        = string
  description = "dns zone name when creating the dns zone via this terraform"
  default     = ""
}