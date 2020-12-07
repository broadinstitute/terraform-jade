## core-infrastructure vars
google_project   = "terra-datarepo-production"
k8_network_name  = "production-network"
k8_subnet_name   = "production-subnet"
enable_flow_logs = "true"
node_regions = {
  jade-node-us-central-1 = {
    region = "us-central1"
  }
  jade-node-us-central-2 = {
    region = "us-central1"
  }
}
## datarepo-app vars
dns_name     = "data"
environment  = "production"
ip_only      = "true"
argocd_cidrs = ["34.68.105.207/32", "35.184.212.129/32"]
## alerting
host     = "data.terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
## production sinks
enable_bigquery   = "true"
enable_gcs        = "true"
enable_monitoring = "true"
