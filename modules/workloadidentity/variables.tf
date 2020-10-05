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
