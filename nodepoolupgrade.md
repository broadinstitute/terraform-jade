## Upgrading kubernetes Nodepool

[Source article for Gcloud commands](https://cloud.google.com/kubernetes-engine/docs/tutorials/migrating-node-pool)

To migrate these Pods to the new node pool, you must perform the following steps:

1. Cordon the existing node pool: This operation marks the nodes in the existing node pool (integration-node) as unschedulable. Kubernetes stops scheduling new Pods to these nodes once you mark them as unschedulable.

2. Drain the existing node pool: This operation evicts the workloads running on the nodes of the existing node pool (integration-node) gracefully.

Edit the `jade-us-central-k8s.tf` file and add a new node pool (integration-node-2) with a new resource name and pool name (integration-node-2)

example below:

```
module "k8s-nodes-2" {
  # terraform-shared repo
  source       = "github.com/broadinstitute/terraform-shared.git//terraform-modules/k8s-node-pool?ref=k8s-cluster-monitoring-0.0.3-tf-0.12"
  dependencies = [module.enable-services, module.k8s-master]

  name                     = "${var.node_name}-2"
  master_name              = var.master_name
  location                 = var.region
  node_count               = var.node_count
  machine_type             = var.machine_type
  disk_size_gb             = var.disk_size_gb
  labels                   = var.node_labels
  tags                     = var.node_tags
  enable_workload_identity = var.enable_workload_identity
}
```
After the deployment has successfully deployed get the labels of the pool you want to decommission. In this example we want to decommission the original `integration-node`
```
# get pool names
▶ kubectl get nodes -o yaml | grep nodepool
      cloud.google.com/gke-nodepool: integration-node
      cloud.google.com/gke-nodepool: integration-node-2
      cloud.google.com/gke-nodepool: integration-node-2
      cloud.google.com/gke-nodepool: integration-node-2
      cloud.google.com/gke-nodepool: integration-node
      cloud.google.com/gke-nodepool: integration-node
# pick specifc nodes from label
▶ kubectl get nodes -l cloud.google.com/gke-nodepool=integration-node
NAME                                                  STATUS   ROLES    AGE   VERSION
gke-integration-mast-integration-node-5a0e509b-6mxd   Ready    <none>   17d   v1.15.9-gke.24
gke-integration-mast-integration-node-ec19a967-jd6v   Ready    <none>   17d   v1.15.9-gke.24
gke-integration-mast-integration-node-ff69c134-f2kz   Ready    <none>   17d   v1.15.9-gke.24
```
Now we want to cordon the nodes marking the nodes as unschedulable.

```
# cordon nodes
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=integration-node -o=name); do
  kubectl cordon "$node";
done

# check for cordon nodes
▶ kubectl get nodes
NAME                                                  STATUS                     ROLES    AGE   VERSION
gke-integration-mast-integration-node-5a0e509b-6mxd   Ready,SchedulingDisabled   <none>   17d   v1.15.9-gke.24
gke-integration-mast-integration-node-8e0d4b1e-bnzr   Ready                      <none>   15h   v1.15.9-gke.24
gke-integration-mast-integration-node-a1451288-wdcf   Ready                      <none>   15h   v1.15.9-gke.24
gke-integration-mast-integration-node-dd57e8a0-xfhk   Ready                      <none>   15h   v1.15.9-gke.24
gke-integration-mast-integration-node-ec19a967-jd6v   Ready,SchedulingDisabled   <none>   17d   v1.15.9-gke.24
gke-integration-mast-integration-node-ff69c134-f2kz   Ready,SchedulingDisabled   <none>   17d   v1.15.9-gke.24
```
The following shell command iterates each node in integration-node and drains them by evicting Pods with an allotted graceful termination period of 10 seconds:
```
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=integration-node -o=name); do
  kubectl drain --ignore-daemonsets --delete-local-data "$node";
done
```
**Note: This is not seemless as the pods in the previous node pool will be taken down and be redeployed you will have to wait for health checks and ingresses to comeback up (1-5min outage)**

check what nodes the pods are running on
```
▶ kubectl get pods --all-namespaces -o wide
```
