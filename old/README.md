## terraform-jade
### Overview
jade Team Terraform configurations will create a internal gcp network and create a small 3 node Kubernetes cluster

#### Before cloning this repo

Create one directory for each environment you will want to update: `dev`, `prod`

Clone this repository into each directory.

### Set Up Your Vault Token

Follow the instructions [here](https://github.com/broadinstitute/dsde-toolbox#authenticating-to-vault) to generate your vault token.

### Use `mkEnv.sh` to render the terraform templates

Some of the files in this repo are `.tf.ctmpl` files. These are templates
that get rendered using values from Vault. Before you can use Terraform, and after
each change that you make to terraform or to values in Vault, you must
re-render the templates. To render the templates, first `cd` into the root directory
of this repo in the environment you want to modify, then run:

```
docker run --rm -it -v "$PWD":/working \
  -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox \
  ./mkEnv.sh -e <env> [-s <suffix>]
```

Usage guidance:

`<env>` - the environment used to pull secrets from Vault (`dev` or `prod`).

[Optional] `<suffix>` - matches GCP project with naming convention
`broad-jade-<suffix>`.
- When unspecified, defaults to `<env>` (e.g. project broad-jade-dev)
- For our Terra production instance, the suffix is terra
  (e.g. project broad-jade-terra)


### Run Terraform Init

The _first_ time you use a repo, and every time one of the terraform
providers change, you will need to run `./terraform.sh init` from within
the repo.

### Using `./terraform.sh` to run Terraform commands

Instead of running Terraform locally, we use a docker container with a
specific version of Terraform installed. To run it, use the `./terraform.sh`
script. Any arguments you pass to the script will be passed to Terraform,
so you can use it exactly as you would the `terraform` command.

### New Team Member Process

[Edit this file](https://github.com/broadinstitute/terraform-jade/blob/master/old/dev.tf.ctmpl)

Following these instructions will allow a new Jade team member
to generate the static resources needed to deploy their personal development environment.

#### User's initials: nu
- name: New User

#### Add your initials to the [default list](https://github.com/broadinstitute/terraform-jade/blob/ddf15bd875fdab66f6545f73e4322c1ff6f49a36/old/dev.tf.ctmpl#L10-L31)
```
variable "initials" {
  type = list(string)
  default = [
  "ms",
  "mk",
  ...
  "nu"
  ]
}
```
#### Add your IP and DNS blocks to [locals.initialrecords](https://github.com/broadinstitute/terraform-jade/blob/ddf15bd875fdab66f6545f73e4322c1ff6f49a36/old/dev.tf.ctmpl#L33-L172)
```
jade-global-nu = {
  type = "A"
  rrdatas = "${google_compute_global_address.jade-initials-ip["nu"].address}"
},
jade-nu = {
  type = "CNAME"
  rrdatas = "jade-global-nu.datarepo-{{$environment}}.broadinstitute.org."
}
```

#### Run Commands
```
docker run --rm -it -v "$PWD":/working \
  -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox:consul-0.20.0 \
  ./mkEnv.sh -e dev
./terraform.sh init
./terraform.sh plan
./terraform.sh apply
```

#### Verifying Outcomes

For each [instance](https://console.cloud.google.com/sql/instances?project=broad-jade-dev)
in GCP SQL with project `broad-jade-dev`,
list all databases (you may need to expand rows per page).

You should see yours in there with name `datarepo-nu`.

Here is a [concrete example](https://console.cloud.google.com/sql/instances/jade-postgres-11-8a00fd4d3b/databases?project=broad-jade-dev)
for our existing Postgres 11 instance.
