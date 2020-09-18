module "uptimecheck" {
  source  = "kenju/monitoring-uptimecheck/google"
  version = "0.1.1"
  project = var.google_project
  host    = var.host
  path    = var.path
  notification_channels = [
    google_monitoring_notification_channel.notification_channel.id,
  ]
}

data "vault_generic_secret" "slack_token" {
  path = var.token_secret_path
}

resource "google_monitoring_notification_channel" "notification_channel" {
  display_name = var.environment
  type         = "slack"
  labels = {
    "channel_name" = var.slackchannel
    "auth_token"   = data.vault_generic_secret.slack_token.data["key"]
  }
}
