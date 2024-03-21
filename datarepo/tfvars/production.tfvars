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
cloudsql_tier            = "db-custom-4-15360"
postgres_max_connections = 400
## datarepo-app vars
dns_name    = "data"
environment = "production"
ip_only     = "true"
argocd_cidrs = [
  # dsp-tools (old ArgoCD)
  "34.68.105.207/32",
  "35.184.212.129/32",
  # devops-super-prod (new ArgoCD) 
  "35.225.151.25/32",
  "23.236.61.36/32",
  "104.154.107.181/32",
  "35.238.212.142/32",
  "34.121.179.0/32",
  "34.66.158.169/32",
  "35.188.147.45/32",
  "35.222.192.6/32",
]
datarepo_namespace = "terra-prod"
sql_ksa_name       = "datarepo-gcloud-sqlproxy"
external_folder_ids = [
  "815384374864", # firecloud.org/terra-datarepo
  "43241207445"   # firecloud.org/terra-datarepo-secure
]
## alerting
host     = "data.terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
