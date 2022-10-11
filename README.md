![Terraform Apply](https://github.com/broadinstitute/terraform-jade/workflows/Terraform%20Apply/badge.svg)

# terraform-jade

Terraform code to setup various GCP environments for the Jade Data Repo.

## Quickstart

```sh
git clone https://github.com/broadinstitute/terraform-jade.git
cd datarepo
docker run --rm -it -v "$PWD":/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox:consul-0.20.0 ./mkEnv.sh -e <env>
./terraform.sh init -backend-config=bucket=<google_project>
./terraform.sh plan -var-file=tfvars/<env>.tfvars
./terraform.sh apply -var-file=tfvars/<env>.tfvars
```

Note: for dev, don't worry about the `google_project_iam_binding` service account changes.  Those seem to just swap every time you apply.  Not really worth fixing 
## Variables
- `<env>` should correspond to the environment to deploy (typically either `dev`
or `prod`)
- `<google_project>` is for the statefile its the name of the google project typically

## Github Actions
- On PR a terraform plan will be made for the following environments [`[alpha, perf, staging, production]`](https://github.com/broadinstitute/terraform-jade/blob/ms-tfvars/.github/workflows/terraformPrPlan.yml#L16)
- On merge a terraform Apply will be made for the following environments [`[alpha, perf, staging, production]`](https://github.com/broadinstitute/terraform-jade/blob/ms-tfvars/.github/workflows/terraformPrPlan.yml#L16)
- To not plan add label `skip-ci` to your PR
