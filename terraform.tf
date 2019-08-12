/*
* Configuration of the Terraform Backend Storage
*/
terraform {
  backend "gcs" {
    bucket = "broad-dsp-terraform-state"
    path = "jade/dev-ms"
    credentials = "tfstate_svc.json"
  }
}
