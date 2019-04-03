

variable "google_project" {
  default = "broad-jade-dev"
  description = "The Google project name"
}

variable "region" {
  default = "us-central1"
  description = "The deployment region"
}

variable "project_network_name" {

    default = "broad-jade-network"

}
variable "env" {
  default = "dev"
}
variable "broad_range_cidrs" {
  default = [
  {
    cidr_block = "69.173.64.0/19"
  },
  {
    cidr_block = "69.173.96.0/20"
  },
  {
    cidr_block = "69.173.112.0/21"
  },
  {
    cidr_block = "69.173.120.0/22"
  },
  {
    cidr_block = "69.173.124.0/23"
  },
  {
    cidr_block = "69.173.126.0/24"
  },
  {
    cidr_block = "69.173.127.0/25"
  },
  {
    cidr_block = "69.173.127.128/26"
  },
  {
    cidr_block = "69.173.127.192/27"
  },
  {
    cidr_block = "69.173.127.224/30"
  },
  {
    cidr_block = "69.173.127.228/32"
  },
  {
    cidr_block = "69.173.127.230/31"
  },
  {
    cidr_block = "69.173.127.232/29"
  },
  {
    cidr_block = "69.173.127.240/28"
  }
  ]
}
variable "broad_routeable_net" {
   default = "69.173.64.0/18"
   description = "Broad's externally routable IP network"
}

