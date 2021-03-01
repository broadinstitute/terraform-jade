resource "google_kms_key_ring" "db" {
  location = "us-central1"
  name     = "${var.environment}-db"
  project  = var.google_project
}

resource "google_kms_crypto_key" "db" {
  name       = var.environment
  key_ring   = google_kms_key_ring.db.self_link
  depends_on = [google_kms_key_ring.db]
}
