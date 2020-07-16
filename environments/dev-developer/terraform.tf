/*
* Configuration of the Terraform Backend Storage
*/
terraform {
  backend "gcs" {
    bucket      = "broad-jade-dev-statefile"
    path        = "jade/dev-core-infra-developer"
    credentials = "env_svc.json"
  }
}

provider "google" {
  credentials = file("env_svc.json")
  project     = var.google_project
  region      = var.region
  version     = "~> 3.30.0"
}

provider "google-beta" {
  credentials = file("env_svc.json")
  project     = var.google_project
  region      = var.region
  version     = "~> 3.30.0"
}

provider "google-beta" {
  alias       = "dns"
  credentials = file("env_svc.json")
  project     = var.dns_project
  region      = var.region
  version     = "~> 3.30.0"
}

provider "vault" {
  alias   = "broad"
  address = "https://clotho.broadinstitute.org:8200"
}
