# terraform-jade

Terraform code to setup various GCP environments for the Jade Data Repo.

## Quickstart

```sh
git clone https://github.com/broadinstitute/terraform-jade.git
cd terraform-jade/environments/<env>
./mkEnv.sh -e <env> -s <suffix>
./terraform.sh init
./terraform.sh plan
#./terraform.sh apply
```
