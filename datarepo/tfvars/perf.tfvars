## core-infrastructure vars
google_project  = "broad-jade-perf"
k8_network_name = "perf-network"
k8_subnet_name  = "perf-subnet"
enable_os_login = true
## datarepo-app vars
dns_name           = "jade-perf"
environment        = "perf"
ip_only            = "false"
dns_zone           = "datarepo-perf"
argocd_cidrs       = ["35.202.125.180/32", "34.70.76.7/32"]
datarepo_namespace = "perf"
sql_ksa_name       = "perf-jade-gcloud-sqlproxy"
external_folder_ids = [
  "270278425081", # data.test-terra.bio/repos/jade-dev
  "753276429356" # data.test-terra.bio/repos/jade-dev/jade-dev-refoldering-test
]
## alerting
host     = "jade-perf.datarepo-perf.broadinstitute.org"
gsa_name = "prometheus-sa"
ksa_name = "datarepo-monitoring-kube-p-prometheus"
