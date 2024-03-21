## core-infrastructure vars
google_project  = "broad-jade-perf"
k8_network_name = "perf-network"
k8_subnet_name  = "perf-subnet"
## datarepo-app vars
dns_name    = "jade-perf"
environment = "perf"
ip_only     = "false"
dns_zone    = "datarepo-perf"
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
datarepo_namespace = "perf"
sql_ksa_name       = "perf-jade-gcloud-sqlproxy"
external_folder_ids = [
  "270278425081", # data.test-terra.bio/repos/jade-dev
  "753276429356"  # data.test-terra.bio/repos/jade-dev/jade-dev-refoldering-test
]
## alerting
host     = "jade-perf.datarepo-perf.broadinstitute.org"
gsa_name = "prometheus-sa"
ksa_name = "datarepo-monitoring-kube-p-prometheus"
