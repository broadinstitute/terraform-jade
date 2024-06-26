module "uptimecheck" {
  source = "github.com/broadinstitute/terraform-google-monitoring-uptimecheck?ref=v0.1.2"
  enable = var.enable
  providers = {
    google.target      = google.target
    google-beta.target = google-beta.target
  }
  project = var.google_project
  host    = var.host
  path    = var.path
  notification_channels = [
    google_monitoring_notification_channel.notification_channel[0].id,
    google_monitoring_notification_channel.workbench_notification_channel[0].id,
  ]
}

data "vault_generic_secret" "slack_token" {
  provider = vault.target
  path     = var.token_secret_path
}

resource "google_monitoring_notification_channel" "notification_channel" {
  count        = var.enable ? 1 : 0
  provider     = google-beta.target
  display_name = var.environment
  type         = "slack"
  labels = {
    "channel_name" = var.slack_channel
  }
  sensitive_labels {
    auth_token = data.vault_generic_secret.slack_token.data["key"]
  }
}

resource "google_monitoring_notification_channel" "workbench_notification_channel" {
  count        = var.enable ? 1 : 0
  provider     = google-beta.target
  display_name = var.workbench_alert_name
  type         = "slack"
  labels = {
    "channel_name" = var.workbench_slack_channel
  }
  sensitive_labels {
    auth_token = data.vault_generic_secret.slack_token.data["key"]
  }
}

module "k8s-cluster-alerts" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/stackdriver/k8s-cluster-monitoring?ref=stackdriver-0.2.1"
  providers = {
    google.target = google.target
  }

  project = var.google_project
  notification_channels = [
    google_monitoring_notification_channel.notification_channel[0].id,
    google_monitoring_notification_channel.workbench_notification_channel[0].id
  ]
}
