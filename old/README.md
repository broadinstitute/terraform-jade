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
docker run --rm -it -v "$PWD":/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox ./mkEnv.sh -e <env> [-s <suffix>]
```

where `<env>` is the environment used to pull secrets from valut (either `dev` or `prod`) and where the optional `<suffix>` is set to the project suffix (e.g. `integration` when the project is broad-jade-integration). When the suffix is the same as the env, you do not need to specify the -s parameter (e.g. broad-jade-dev). For our terra production instance, the suffix is terra (i.e. broad-jade-terra).

### Run Terraform Init

The _first_ time you use a repo, and every time one of the terraform
providers change, you will need to run `./terraform.sh init` from within
the repo.

### Using `./terraform.sh` to run Terraform commands

Instead of running Terraform locally, we use a docker container with a
specific version of Terraform installed. To run it, use the `./terraform.sh`
script. Any arguments you pass to the script will be passed to Terraform,
so you can use it exactly as you would the `terraform` command.

### New Team member process

[Edit this file](https://github.com/broadinstitute/terraform-jade/blob/master/old/dev.tf.ctmpl)

#### Users initials: nu
- name: New User

#### Add blocks for initials, Add blocks for IP and DNS
https://github.com/broadinstitute/terraform-jade/blob/master/old/dev.tf.ctmpl#L10-L28
```
variable "initials" {
  type = list(string)
  default = [
  "ms",
  "mk",
  "rc",
  "mm",
  "fb",
  "my",
  "jh",
  "dd",
  "sh",
  "nm",
  "ps",
  "se",
  "tn",
  "tl",
  "nu"
  ]
}
```
https://github.com/broadinstitute/terraform-jade/blob/master/old/dev.tf.ctmpl#L30-L145
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

#### Commands
```
docker run --rm -it -v "$PWD":/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox:consul-0.20.0 ./mkEnv.sh -e dev
./terraform.sh init
./terraform.sh plan
./terraform.sh apply
```
