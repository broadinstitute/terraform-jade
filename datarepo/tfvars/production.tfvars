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
dns_name           = "data"
environment        = "production"
ip_only            = "true"
argocd_cidrs       = ["34.68.105.207/32", "35.184.212.129/32"]
datarepo_namespace = "terra-prod"
sql_ksa_name       = "datarepo-gcloud-sqlproxy"
external_folder_ids = [
  "815384374864" # firecloud.org/terra-datarepo
]
## alerting
host     = "data.terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
