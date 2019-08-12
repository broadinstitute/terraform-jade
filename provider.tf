provider "google" {
    credentials = file("${var.env}_svc.json")
    project = var.project
    region  = var.region
}

provider "google-beta" {
    credentials = file("${var.env}_svc.json")
    project     = var.project
    region      = var.region
}

provider "google" {
    alias       = "broad-jade"
    credentials = file("${var.env}_svc.json")
    project     = var.env_project
    region      = var.region
}

provider "vault" {
    address = "https://clotho.broadinstitute.org:8200"
}
