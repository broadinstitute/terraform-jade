## core-infrastructure vars
google_project  = "broad-jade-ms"
k8_network_name = "ms-network2"
k8_subnet_name  = "ms-subnet2"
## datarepo-app vars
dns_name      = "jade-ms"
environment   = "ms"
ip_only       = "true"
argocd_cidrs  = ["35.202.125.180/32", "34.70.76.7/32"]
cloudsql_tier = "db-g1-small"
## alerting
host     = "jade-ms.datarepo-ms.broadinstitute.org"
gsa_name = "prometheus-sa"
ksa_name = "datarepo-monitoring-kube-p-prometheus"
## backend config var
bucket = "broad-jade-ms"
