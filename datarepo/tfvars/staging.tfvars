## core-infrastructure vars
google_project  = "terra-datarepo-staging"
k8_network_name = "staging-network"
k8_subnet_name  = "staging-subnet"
node_names      = ["jade-node-us-central1"]
## datarepo-app vars
dns_name      = "data"
environment   = "staging"
ip_only       = "true"
argocd_cidrs  = ["34.68.105.207/32", "35.184.212.129/32"]
cloudsql_tier = "db-g1-small"
## alerting
host     = "data.staging.envs-terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
