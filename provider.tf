provider "google" {
  credentials = file("env_svc.json")
  project     = var.project
  region      = var.region
  version     = "~> 3.2.0"
}

provider "google-beta" {
  credentials = file("env_svc.json")
  project     = var.project
  region      = var.region
  version     = "~> 3.2.0"
}

provider "vault" {
  address = "https://clotho.broadinstitute.org:8200"
}

provider "google" {
  alias       = "broad-jade"
  credentials = file("env_svc.json")
  project     = var.env_project
  region      = var.region
  version     = "~> 3.2.0"
}
