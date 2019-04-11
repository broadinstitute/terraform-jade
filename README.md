## terraform-jade
### Overview
jade Team Terraform configurations will create a internal gcp network and create a small 3 node Kubernetes cluster

#### Dependencies
Terraform Verion 2.X.X or higher
- for the private ip for cloudsql instance
Service account for Terraform
- Needs "Service Networking Admin" permissions


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
docker run --rm -it -v "$PWD":/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox ./mkEnv.sh -p jade -e <env>
```

replacing `<env>` with the name of the environment.
Variables for `<env>` are below.
- `dev`
### Run Terraform Init

The _first_ time you use a repo, and every time one of the terraform
providers change, you will need to run `./terraform.sh init` from within
the repo.

### Using `./terraform.sh` to run Terraform commands

Instead of running Terraform locally, we use a docker container with a
specific version of Terraform installed. To run it, use the `./terraform.sh`
script. Any arguments you pass to the script will be passed to Terraform,
so you can use it exactly as you would the `terraform` command.
