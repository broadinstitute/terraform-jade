## core-infrastructure vars
variable "google_project" {
  type        = string
  description = "The google project being deployed to"
  default     = "broad-jade-dev"
}

variable "k8_network_name" {
  default     = "developer-network"
  description = "core network name to be deployed and put k8 cluster on"
}

variable "k8_subnet_name" {
  description = "name of the subnet within the networking being deployed"
  default     = "developer-subnet"
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

variable "dns_project" {
  type        = string
  default     = "broad-jade-dev"
  description = "The Google project name where dns zone is"
}

variable "version_prefix" {
  type        = string
  default     = "1.16.8-gke.15"
  description = "version of gke to be deployed"
}

## datarepo-app vars
variable dns_zone {
  default     = "datarepo-dev"
  description = "The name of managed dns zone to put cname and a record in"
}

variable dns_names {
  type        = list(string)
  description = "List of DNS names to generate global IP addresses, A-records, and CNAME-records for."
  default     = ["jade-foo"]
}

variable "db_version" {
  type        = string
  description = "Postgres db verion"
  default     = "POSTGRES_11"
}

variable "environment" {
  description = "environment being deployed"
  default     = "dev"
}

variable "developer_dns" {
  type = list(string)
  default = [
    "jade-ms",
    "jade-mk",
    "jade-rc",
    "jade-mm",
    "jade-fb",
    "jade-my",
    "jade-jh",
    "jade-dd",
    "jade-sh"
  ]
}

variable "developer_dbs" {
  type = list(string)
  default = [
    "ms",
    "mk",
    "rc",
    "mm",
    "fb",
    "my",
    "jh",
    "dd",
    "sh"
  ]
}
