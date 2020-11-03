/*
* Configuration of the Terraform Backend Storage
*/
terraform {
  backend "gcs" {
    path        = "jade/tf-statefile"
    credentials = "env_svc.json"
  }
}

provider "google" {
  credentials = file("env_svc.json")
  project     = var.google_project
  region      = var.region
  version     = "~> 3.31.0"
}

provider "google-beta" {
  credentials = file("env_svc.json")
  project     = var.google_project
  region      = var.region
  version     = "~> 3.31.0"
}

provider "vault" {
  alias   = "broad"
  address = "https://clotho.broadinstitute.org:8200"
}
