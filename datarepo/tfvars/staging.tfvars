## core-infrastructure vars
google_project  = "terra-datarepo-staging"
k8_network_name = "staging-network"
k8_subnet_name  = "staging-subnet"
## datarepo-app vars
dns_name           = "data"
environment        = "staging"
ip_only            = "true"
argocd_cidrs       = ["34.68.105.207/32", "35.184.212.129/32"]
datarepo_namespace = "terra-staging"
sql_ksa_name       = "datarepo-gcloud-sqlproxy"
## alerting
host     = "data.staging.envs-terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
