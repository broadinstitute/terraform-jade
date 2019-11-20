provider "google" {
    credentials = file("${var.env}_svc.json")
    project = var.project
    region  = var.region
    version     = "~>2.20.0"
}

provider "google-beta" {
    credentials = file("${var.env}_svc.json")
    project     = var.project
    region      = var.region
    version     = "~>2.20.0"
}

provider "google" {
    alias       = "broad-jade"
    credentials = file("${var.env}_svc.json")
    project     = var.env_project
    region      = var.region
    version     = "~>2.20.0"
}

provider "vault" {
    address = "https://clotho.broadinstitute.org:8200"
}
