## core-infrastructure vars
google_project  = "terra-datarepo-alpha"
k8_network_name = "alpha-network"
k8_subnet_name  = "alpha-subnet"
## datarepo-app vars
dns_name    = "data"
environment = "alpha"
ip_only     = "true"
argocd_cidrs = [
  # dsp-tools (old ArgoCD)
  "34.68.105.207/32", "35.184.212.129/32",
  # devops-super-prod (new ArgoCD) 
  "35.225.151.25/32", "23.236.61.36/32", "104.154.107.181/32", "35.238.212.142/32", "34.121.179.0/32", "34.66.158.169/32", "35.188.147.45/32", "35.222.192.6/32",
]
datarepo_namespace = "terra-alpha"
sql_ksa_name       = "datarepo-gcloud-sqlproxy"
external_folder_ids = [
  "270278425081", # data.test-terra.bio/repos/jade-dev
  "753276429356"  # data.test-terra.bio/repos/jade-dev/jade-dev-refoldering-test
]
## alerting
host     = "data.alpha.envs-terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
