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

`<env>` should correspond to the environment to deploy (typically either `dev`
or `prod`), and `-s <suffix>` may optionally be defined to modify the project
suffix (e.g. `integration` when the project is broad-jade-integration, or `terra`
when the project is `broad-jade-terra`). If `-s <suffix>` is not supplied, it
will use the corresponding `<env>` instead.
