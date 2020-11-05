## core-infrastructure vars
google_project   = "terra-datarepo-production"
k8_network_name  = "production-network"
k8_subnet_name   = "production-subnet"
enable_flow_logs = "true"
## datarepo-app vars
dns_name      = "data"
environment   = "production"
ip_only       = "true"
argocd_cidrs  = ["34.68.105.207/32", "35.184.212.129/32"]
cloudsql_tier = "db-g1-small"
## alerting
host     = "data.terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
## production sinks
enable_bigquery   = "true"
enable_gcs        = "true"
enable_monitoring = "true"