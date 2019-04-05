/*
* Configuration of the Terraform Backend Storage
*/

terraform {
    backend "gcs" {
        bucket = "broad-dsp-terraform-state"
        path = "broad-jade/dev"
        credentials = "tfstate_svc.json"
    }
}
