/*
* Configuration of the Terraform Backend Storage
*/
terraform {
  backend "gcs" {
    bucket = "broad-dsp-terraform-state"
    path = "jade/${var.env}-${var.suffix}"
    credentials = "tfstate_svc.json"
  }
}
