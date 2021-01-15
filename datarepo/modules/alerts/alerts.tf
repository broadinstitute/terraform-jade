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
    "channel_name" = var.slackchannel
    "auth_token"   = data.vault_generic_secret.slack_token.data["key"]
  }
}

module "k8s-cluster-alerts" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/stackdriver/k8s-cluster-monitoring?ref=stackdriver-0.1.1-tf-0.12"
  providers = {
    google.target = google.target
  }

  project = var.google_project
  notification_channels = [
    google_monitoring_notification_channel.notification_channel[0].id
  ]
}

resource "google_logging_metric" "logging_metric_error_connections_exhausted" {
  name   = "logging/user/metric_error_connections_exhausted"
  filter = <<EOT
resource.type="k8s_container"
AND labels.k8s-pod/app_kubernetes_io/name="datarepo-api"
AND resource.labels.project_id="${var.google_project}"
AND resource.labels.cluster_name="${var.k8_cluster_name}"
AND severity="ERROR"
AND (jsonPayload.message:"Global exception handler" AND jsonPayload.message:"org.springframework.jdbc.CannotGetJdbcConnectionException")
EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_monitoring_alert_policy" "log_based_alert_policy" {
  display_name = "Error was detected"
  combiner     = "OR"
  conditions {
    display_name = "Connections Exhausted"
    condition_threshold {
      filter     = "metric.type=\"${google_logging_metric.logging_metric_error_connections_exhausted.name}}\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }
  project = var.google_project
  notification_channels = [
    google_monitoring_notification_channel.notification_channel[0].id
  ]
}