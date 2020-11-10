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
  description = "The google project being deployed to"
}

variable "k8_network_name" {
  type        = string
  default     = null
  description = "core network name to be deployed and put k8 cluster on"
}

variable "k8_subnet_name" {
  type        = string
  description = "name of the subnet within the networking being deployed"
  default     = null
}

variable "gke_subnet_pods" {
  type        = string
  default     = "10.127.0.0/20"
  description = "Secondary CIDR range for the cluster's pods"
}

variable "gke_subnet_services" {
  type        = string
  default     = "10.0.16.0/20"
  description = "Secondary CIDR range for the cluster's services"
}

variable "version_prefix" {
  type        = string
  default     = "1.16.8-gke.15"
  description = "version of gke to be deployed"
}

locals {
  master_name = "${var.environment}-master-${var.region}"
}

locals {
  node_name = "${var.environment}-node-${var.region}"
}

variable "node_names" {
  type        = list
  description = "Name of node pools will create a pool for every name "
  default     = []
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

variable "private_ipv4_cidr_block" {
  type        = string
  description = "private cidr for kubernetes"
  default     = "10.227.0.0/28"
}

variable "disk_size_gb" {
  type        = number
  description = "disk size for kubernetes nodes"
  default     = "50"
}

locals {
  node_labels = {
    project     = var.google_project,
    environment = var.environment
  }
}

locals {
  node_tags = [
    var.google_project,
    var.environment,
    "kubernetes"
  ]
}

variable "gke_release_channel" {
  type        = string
  description = "Release channel"
  default     = "REGULAR"
}

variable "enable_workload_identity" {
  type        = bool
  description = "enable workload id on kubenetes cluster"
  default     = "true"
}

variable "enable_flow_logs" {
  type        = bool
  default     = "false"
  description = "flag for enabling flowlog"
}

variable "region" {
  type        = string
  description = "GCP region being used"
  default     = null
}

variable "dns_zone_name" {
  type        = string
  description = "If not null will create a DNS Zone"
  default     = ""
}

variable "broad_range_cidrs" {
  description = "default broad external ips"
  type        = list
  default = [
    "69.173.112.0/21",
    "69.173.127.232/29",
    "69.173.127.128/26",
    "69.173.127.0/25",
    "69.173.127.240/28",
    "69.173.127.224/30",
    "69.173.127.230/31",
    "69.173.120.0/22",
    "69.173.127.228/32",
    "69.173.126.0/24",
    "69.173.96.0/20",
    "69.173.64.0/19",
    "69.173.127.192/27",
    "69.173.124.0/23"
  ]
}

variable "argocd_cidrs" {
  description = "argocd broad external ips to be added to the master auth network"
  type        = list
  default     = []
}

locals {
  broad_range_cidrs = var.argocd_cidrs != "" ? concat(var.broad_range_cidrs, var.argocd_cidrs) : var.broad_range_cidrs
}
