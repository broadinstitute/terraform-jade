module "uptimecheck" {
  source       = "github.com/broadinstitute/terraform-google-monitoring-uptimecheck?ref=ms-edits"
  enable       = var.enable
  dependencies = var.dependencies
  providers = {
    google.target = google.target
    google-beta.target = google-beta.target
  }
  project      = var.google_project
  host         = var.host
  path         = var.path
  notification_channels = [
    google_monitoring_notification_channel.notification_channel[0].id,
  ]
}

data "vault_generic_secret" "slack_token" {
  provider   = vault.target
  path       = var.token_secret_path
  depends_on = [var.dependencies]
}

resource "google_monitoring_notification_channel" "notification_channel" {
  count        = var.enable ? 1 : 0
  provider     = google-beta.target
  display_name = var.environment
  type         = "slack"
  labels = {
    "channel_name" = var.slackchannel
    "auth_token"   = data.vault_generic_secret.slack_token.data["key"]
  }
  depends_on = [var.dependencies]
}

module "k8s-cluster-alerts" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/stackdriver/k8s-cluster-monitoring?ref=stackdriver-0.1.0-tf-0.12"
  providers = {
    google.target = google.target
  }

  project = var.google_project
  notification_channels = [
    google_monitoring_notification_channel.notification_channel[0].id
  ]
}
