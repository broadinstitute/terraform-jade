#
# jade cloudsql instance
#

resource "random_id" "jade_100_randomid" {
  count       = var.jade_cloudsql_100_num_instances
  byte_length = 8
  depends_on  = [module.enable-services]
}

resource "google_sql_database_instance" "jade_100_postgres" {
  provider         = google-beta
  count            = var.jade_cloudsql_100_num_instances
  region           = var.region
  database_version = "POSTGRES_9_6"
  name = format(
    "jade-postgres-1%02d-%s",
    count.index + 1,
    element(random_id.jade_100_randomid.*.hex, count.index),
  )
  depends_on = [
    module.enable-services,
    google_service_networking_connection.private_vpc_connection,
  ]

  settings {
    activation_policy = var.cloudsql_activation_policy
    pricing_plan      = var.cloudsql_pricing_plan
    replication_type  = var.cloudsql_replication_type
    tier              = var.jade_cloudsql_100_instance_size

    backup_configuration {
      binary_log_enabled = false
      enabled            = true
      start_time         = "06:00"
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.jade-network.self_link
      require_ssl     = var.cloudsql_require_ssl
      authorized_networks {
        name  = "Broad"
        value = var.broad_routeable_net
      }

      authorized_networks {
        name  = "kubernetes"
        value = google_compute_global_address.jade-k8-ip["jade"].address
      }
    }

    user_labels = {
      app   = "jade"
      role  = "database"
      state = "active"
    }

    database_flags {
      name  = "max_connections"
      value = 1024
    }
  }
}


#####
resource "random_id" "db_name_suffix" {
  byte_length = 5
}

resource "google_sql_database_instance" "jade_11_postgres_db" {
  provider         = google-beta
  count            = var.jade_cloudsql_100_num_instances
  region           = var.region
  database_version = "POSTGRES_11"
  name             = "jade-postgres-11-${random_id.db_name_suffix.hex}"
  depends_on = [
    module.enable-services,
    google_service_networking_connection.private_vpc_connection,
  ]

  settings {
    activation_policy = var.cloudsql_activation_policy
    pricing_plan      = var.cloudsql_pricing_plan
    replication_type  = var.cloudsql_replication_type
    tier              = "db-custom-2-7680"

    backup_configuration {
      binary_log_enabled = false
      enabled            = true
      location           = "us"
      start_time         = "06:00"
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.jade-network.self_link
      require_ssl     = var.cloudsql_require_ssl
      authorized_networks {
        name  = "Broad"
        value = var.broad_routeable_net
      }

      authorized_networks {
        name  = "kubernetes"
        value = google_compute_global_address.jade-k8-ip["jade"].address
      }
    }

    user_labels = {
      app   = "jade"
      role  = "database"
      state = "active"
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    database_flags {
      name  = "log_statement"
      value = "all"
    }
  }
}
