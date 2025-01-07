[![Static analysis](https://github.com/hajle-silesia/provisioning/actions/workflows/static-analysis.yaml/badge.svg)](https://github.com/hajle-silesia/provisioning/actions/workflows/static-analysis.yaml)[![Toolbox CI](https://github.com/hajle-silesia/provisioning/actions/workflows/toolbox-ci.yaml/badge.svg)](https://github.com/hajle-silesia/provisioning/actions/workflows/toolbox-ci.yaml)

## About

Repository for provisioning [K3s](https://docs.k3s.io/) container orchestration tool, basing on [always free](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) infrastructure resources from Oracle Cloud Infrastructure.

## Repository

### Structure

General overview of the repository structure. Not all files/directories are listed, only these that are specific to the tools in the repository.
```shell
.
├── .github                 # GitHub config files
│   ├── workflows           # GitHub Actions config files
│   └── renovate.json       # Renovate config
├── .spacelift              # Spacelift config files
│   └── workflow.yml        # Spacelift workflow tool config file
├── certificates            # Certificates
├── components              # Terraform root modules
├── machine-images          # Source files for machine images
├── modules                 # Terraform modules
│   ├── <module-0>          # Source files for Terraform <module-0>
│   └── ...                 # Other modules
├── stacks                  # Atmos stacks
├── toolbox                 # Toolbox config files
│   ├── rootfs              # Atmos config file dir
│   ├── .gitconfig
│   ├── .mise.toml          # Mise config file
│   └── Dockerfile
├── .pre-commit-config.yaml # Pre-commit config file
├── .trivyignore.yaml       # Trivy config file
├── README.md
├── vendor.yaml             # Atmos vendor config
```

### Setup

`hajlesilesia/provisioning` Docker image is a preferred way to distribute the tools used in this repository. It's designed to bring consistency for local and [remote](.github/workflows) usage by being cross-platform (macOS, Linux, WSL), multi architecture (linux/amd64, linux/arm64), version controlled and reusable.

Run once:

```shell
docker run --rm hajlesilesia/provisioning:latest init | bash
```

Run every time new version was released and updated in the workflows files (for consistency with remote workflows):

```shell
docker pull hajlesilesia/provisioning:latest
```

Run on daily basis, preferably as a main terminal:

```shell
provisioning
```

Before cloning any repository, create `.env` file with the following content in your local organization directory:

```shell
#!/usr/bin/env bash

git config --global user.email <email>
git config --global user.name <username>

# Due to volume mounts of the image, permission issues may occur. Observed examples:
# - PyCharm installed on Windows, codebase located in WSL 2 - autosave and backup denied for files created from container.
umask 0
```

Then, run:

```shell
. .env
git clone <repo-name>
cd "$(basename "$_" .git)"
touch .env
```

Copy following content into the `.env` file in your local repository directory:

```shell
#!/usr/bin/env bash

. ../.env

# Pre-commit needs to be installed to allow `git` actions (e.g. pre-commit, pre-push, etc.)
pre-commit install
```

Then, run:

```shell
. .env
```

Note: always source `.env` file (run: `. .env`) after starting container to avoid permission issues between host/container.

Example: static analysis with hooks managed by pre-commit can be executed by running:

```shell
pre-commit --all-files --hook-stage manual
```

Following CLI tools are contained within the image:

| Name                                                                                                  | Description                                       |
|-------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| [mise](https://mise.jdx.dev/getting-started.html)                                                     | Tool version manager                              |
| [k3s](https://docs.k3s.io/quick-start)                                                                | Container orchestration                           |
| [oci](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm#Quickstart)               | Oracle Cloud Infrastructure cloud provider        |
| [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)          | Infrastructure provisioning, static analysis      |
| [atmos](https://atmos.tools/install/)                                                                 | Cloud architecture framework for native Terraform |
| [tflint](https://github.com/terraform-linters/tflint#installation)                                    | Static analysis                                   |
| [trivy](https://aquasecurity.github.io/trivy/latest/getting-started/installation/)                    | Static analysis                                   |
| [pre-commit](https://pre-commit.com/)                                                                 | Managing pre-commit hooks                         |
| [helm](https://helm.sh/docs/intro/install/)                                                           | Container orchestration package manager           |
| [packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) | Machine images provisioning                       |

### Dependency updates

[Renovate](https://docs.renovatebot.com/) is used as a tool for automated dependency updates. Although it handles many dependencies out of the box, there are many that are not supported yet. These have to be taken care of separately via [config file](.github/renovate.json). Verify periodically all dependencies against Renovate latest documentation/config file, to see if dependency support is added/separate handling is still needed. See [Renovate console](https://developer.mend.io/github/hajle-silesia/provisioning) for scanning details.

### Static analysis

Dedicated Docker image is a preferred way to run static analysis as it brings consistency for local and [remote](.github/workflows/static-analysis.yaml) usage.

Run once, to install hooks in the repository:

```shell
pre-commit install
```

Following static analysis tools are contained within the image with pre-commit hooks serving as an execution tool with following [configuration](.pre-commit-config.yaml).

| Name                                                                                  | Description                    |
|---------------------------------------------------------------------------------------|--------------------------------|
| [pre-commit for Terraform](https://github.com/antonbabenko/pre-commit-terraform)      | Hooks manager                  |
| [Terraform fmt](https://developer.hashicorp.com/terraform/cli/commands/fmt)           | Canonical format check         |
| [Terraform validate](https://developer.hashicorp.com/terraform/cli/commands/validate) | Configuration files validation |
| [TFLint](https://github.com/terraform-linters/tflint)                                 | Linter                         |
| [Trivy](https://github.com/aquasecurity/trivy)                                        | Security vulnerabilities check |

### Deployment

Depending on the phase of software delivery, [Atmos workflows](https://atmos.tools/core-concepts/workflows)/[Spacelift](https://spacelift.io/) is used as a tool for orchestration of infrastructure provisioning. 

#### Pre-requisites

1. Create Oracle Cloud Infrastructure account.
1. Upgrade Free Tier account to a paid account. Paid accounts precede Free Tier accounts when it comes to resources (especially instances) provisioning by OCI. For Free Tier accounts it can take hours.
1. [Optional] Create budgets to control costs. Paid account billing charges specified payment method according to the resource tier type.
1. Generate API key for your user as described [here](https://docs.oracle.com/en-us/iaas/Content/terraform/configuring.htm#APIKeyAuth).
1. Create S3-compatible backend as described [here](https://docs.oracle.com/en-us/iaas/Content/terraform/object-storage-state.htm#s3).
1. Generate customer secret key for your profile as described [here](https://docs.oracle.com/en-us/iaas/Content/terraform/object-storage-state.htm#auth).

#### Day-1

Atmos workflows are used for cold starts. See configuration [here](stacks/workflows). Execute these commands for full deployment:

```shell
atmos workflow apply-all-components -f foundation

# Create vault secrets here as they are needed for provisioning platform environment

atmos workflow apply-all-components -f plat-env -s plat-fra-prod
```

#### Day-2

 Spacelift is configured to work with Atmos as described [here](https://docs.cloudposse.com/layers/spacelift/). See [Spacelift console](https://hajle-silesia.app.spacelift.io/) for configuration details. [Custom workflow tool](https://docs.spacelift.io/vendors/terraform/workflow-tool) is defined [here](.spacelift/workflow.yml) due to Terraform FOSS version constraints.
Additional information:
- [Spacelift components](https://docs.cloudposse.com/components/library/aws/spacelift/)
- [Spacelift admin stack component](https://github.com/cloudposse-terraform-components/aws-spacelift-admin-stack)
- [Spacelift spaces component](https://github.com/cloudposse-terraform-components/aws-spacelift-spaces)
- [Spacelift as TACOS](https://docs.cloudposse.com/layers/spacelift/)

### Version management and package publishing

[semantic-release](https://semantic-release.gitbook.io/semantic-release/) is used as a tool for automated version management and package publishing. See configuration [here](.github/workflows/release.yaml).

## Architecture

### Immutable infrastructure

To avoid configuration drift and shorten deployment time for newly spun instances, immutable infrastructure is a preferred solution for provisioning machine images. [HashiCorp Packer](https://www.packer.io/) is used as a tool for building them.

### Secrets management

OCI Vault is used as a secrets management solution for the cluster. Dedicated secret (see vault module config) stores the cluster initialization flag, useful for server nodes during cold start (spinning new cluster). [External Secrets Operator](https://external-secrets.io/latest/) automatically generates cluster secrets from the data stored within the vault as described [here](https://external-secrets.io/latest/provider/oracle-vault/).

### DNS

Hostnames are used for network resources to allow wildcard certificate usage with name defined as described [here](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/dns.htm#About). Certificate is used in the vault setup. Otherwise, certificate would have to be updated each time private IP address of network resource (VPC, subnet, instance, load balancer, etc.) change.

## Access to cluster

```
terraform init
terraform workspace list
terraform workspace select default
mkdir -p ~/.kube
terraform output -raw kubeconfig > ~/.kube/config-google-cloud
echo 'export KUBECONFIG=~/.kube/config-google-cloud' >> ~/.bashrc
kubectl get nodes
```
