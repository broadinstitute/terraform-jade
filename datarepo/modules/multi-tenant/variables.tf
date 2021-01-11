variable "enable" {
  type        = bool
  description = "Enable flag for this module. If set to false, no resources will be created."
  default     = true
}

variable "google_project" {
  type        = string
  description = "The google project"
}

variable "sql_server_name" {
  type        = string
  description = "The google sql servers name"
}

variable "dns_zone" {
  type        = string
  default     = ""
  description = "The name of managed dns zone to put cname and a record in"
}

variable "dns_names" {
  type        = list(string)
  description = "List of DNS names to generate global IP addresses, A-records, and CNAME-records for."
}

variable "workloadid_names" {
  type        = list(string)
  description = "List of DNS names to generate global IP addresses, A-records, and CNAME-records for."
}

variable "db_names" {
  type        = list(string)
  description = "List of DB names to generate"
}
