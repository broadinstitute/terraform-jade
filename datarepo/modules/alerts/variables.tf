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

variable "slackchannel" {
  type        = string
  description = "The slack channel to report to"
  default     = "#jade-alerts"
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

variable "namespace" {
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
