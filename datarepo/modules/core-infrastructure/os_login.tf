# DDO-1955, CIS Benchmark 4.4 
# https://cloud.google.com/compute/docs/oslogin/set-up-oslogin#enable_oslogin
resource "google_compute_project_metadata_item" "os-login" {
  project = var.google_project
  key     = "enable-oslogin"
  value   = var.enable_os_login ? "TRUE" : "FALSE"
}
