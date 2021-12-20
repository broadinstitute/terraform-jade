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
external_folder_ids = [
  "270278425081", # data.test-terra.bio/repos/jade-dev  "270278425081", # data.test-terra.bio/repos/jade-dev
  "753276429356", # data.test-terra.bio/repos/jade-dev/jade-dev-refoldering-test
]
## alerting
host     = "data.staging.envs-terra.bio"
gsa_name = "prometheus-sa"
ksa_name = "datarepomonitoring-kube-pr-prometheus"
