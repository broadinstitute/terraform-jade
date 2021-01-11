variable "enable" {
  type        = bool
  description = "Enable flag for this module. If set to false, no resources will be created."
  default     = false
}

variable "enable_bigquery_tables" {
  type    = bool
  default = false
}

variable "environment" {
  type        = string
  description = "team environment being deployed"
  default     = "jade"
}

variable "google_project" {
  type        = string
  description = "The google project being deployed to"
}

variable "application_name" {
  type        = string
  description = "name of application"
  default     = "datarepo"
}

variable "enable_bigquery" {
  default     = 0
  description = "bool to enable bq logging"
}

variable "enable_gcs" {
  default     = 0
  description = "bool to enable gcs logging"
}

variable "enable_pubsub" {
  default     = 0
  description = "bool to enable pub sub logging"
}

variable "bigquery_retention_days" {
  default     = "90"
  description = "number of days to retain bq logs"
}
