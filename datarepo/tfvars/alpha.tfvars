## core-infrastructure vars
google_project  = "terra-datarepo-alpha"
k8_network_name = "alpha-network"
k8_subnet_name  = "alpha-subnet"
## datarepo-app vars
dns_name           = "data"
environment        = "alpha"
ip_only            = "true"
argocd_cidrs       = ["34.68.105.207/32", "35.184.212.129/32"]
datarepo_namespace = "terra-alpha"
sql_ksa_name       = "datarepo-gcloud-sqlproxy"
## alerting
host     = "data.alpha.envs-terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
