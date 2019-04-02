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

## Creating new Terraform stacks

If you need to run [Terraform][1] for an environment locally, you first need to deal with [Terraform][1] state (typically by pulling remote state from [Atlas][2]), and then you would need to create an override file (https://www.terraform.io/docs/configuration/override.html) to fill in the necessary variables with their correct values.  An example of such an override file can be found in the `env_override.tf.sample` file.

Also included in this repository is the `terraform.sh` script.  This script can be used to run the `broadinstitute/terraform` [Docker][3] container with all the correct parameters to run [Terraform][1] correctly.  You will also need a `config.sh` script for `terraform.sh` to work correctly, so a sample `config.sh.sample` file has been provided as well.

[1]: https://terraform.io/ "Terraform"
[2]: https://atlas.hashicorp.com "Atlas"
[3]: https://www.docker.com/ "Docker"
