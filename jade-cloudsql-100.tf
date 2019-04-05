#
# jade cloudsql instance
#

resource "random_id" "jade_100_randomid" {
    count = "${var.jade_cloudsql_100_num_instances}"
    byte_length = 8
}

resource "google_sql_database_instance" "jade_100_postgres" {
    provider = "google"
    count = "${var.jade_cloudsql_100_num_instances}"
    region = "${var.region}"
    database_version = "POSTGRES_9_6"
    name = "${format("jade-postgres-1%02d-%s", count.index+1, element(random_id.jade_100_randomid.*.hex, count.index))}"

    settings {
        activation_policy = "${var.cloudsql_activation_policy}"
        pricing_plan = "${var.cloudsql_pricing_plan}"
        replication_type = "${var.cloudsql_replication_type}"
        tier = "${var.jade_cloudsql_100_instance_size}"

        backup_configuration {
            binary_log_enabled = false
            enabled = true
            start_time = "06:00"
        }

        ip_configuration {
            ipv4_enabled = true
            require_ssl = "${var.cloudsql_require_ssl}"
            authorized_networks = {
                name = "Broad"
                value = "${var.broad_routeable_net}"
            }

        }

        user_labels {
            app = "jade"
            role = "database"
            state = "active"
        }
    }
}

#"${google_dns_managed_zone.dns_zone.name}"
# CloudSQL DNS entry
#
resource "google_dns_record_set" "jade-100-postgres" {
    provider = "google"
    count = "${var.jade_cloudsql_100_num_instances}"
    managed_zone = "${google_dns_managed_zone.jade_zone.name}"
    name = "${format("jade-postgres1%02d.%s", count.index+1, google_dns_managed_zone.jade_zone.name)}"
    type = "A"
    ttl = "300"
    rrdatas = [
        "${element(google_sql_database_instance.jade_100_postgres.*.first_ip_address, count.index)}"]
}
