[![Static analysis](https://github.com/hajle-silesia/provisioning/actions/workflows/static-analysis.yaml/badge.svg)](https://github.com/hajle-silesia/provisioning/actions/workflows/static-analysis.yaml)[![Toolbox CI](https://github.com/hajle-silesia/provisioning/actions/workflows/toolbox-ci.yaml/badge.svg)](https://github.com/hajle-silesia/provisioning/actions/workflows/toolbox-ci.yaml)

## About

Repository for provisioning [K3s](https://docs.k3s.io/) container orchestration tool, basing on [always free](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) infrastructure resources from Oracle Infrastructure Cloud.

## Repository

### Structure

General overview of the repository structure. Not all files/directories are listed, only these that are specific to the tools in the repository.
```shell
.
├── .github                 # GitHub config files
│   ├── workflows           # GitHub Actions config files
│   └── renovate.json       # Renovate config
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
├── .releaserc.yaml         # Semantic-release config file
├── tflint.hcl              # (temporary, until static analysis is migrated) TFLint config file
├── .trivyignore.yaml       # Trivy config file
├── README.md
├── vendor.yaml             # Atmos vendor config
```

### Setup

`mtweeman/hajle-silesia_provisioning-toolbox` Docker image is a preferred way to distribute the tools used in this repository. It's designed to bring consistency for local and [remote](.github/workflows) usage by being cross-platform (macOS, Linux, WSL), multi architecture (linux/amd64, linux/arm64), version controlled and reusable.

Run once:
```shell
docker run --rm mtweeman/hajle-silesia_provisioning-toolbox:latest init | bash
```

Run every time new version was released and updated in the workflows files (for consistency with remote workflows):

```shell
docker pull mtweeman/hajle-silesia_provisioning-toolbox:latest
```

Run on daily basis, preferably as a second terminal, next to the terminal used for `git` commands:

```shell
hajle-silesia_provisioning-toolbox
```

Example: static analysis with hooks managed by pre-commit:

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
| [helm](https://helm.sh/docs/intro/install/)                                                           | Package manager for container orchestration       |
| [packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) | Machine images provisioning                       |

### Dependency updates

[Renovate](https://docs.renovatebot.com/) is used as a tool for automated dependency updates. Although it handles many dependencies out of the box, there are many that are not supported yet. These have to be taken care of separately via [config file](.github/renovate.json). Verify periodically all dependencies against Renovate latest documentation/config file, to see if dependency support is added/separate handling is still needed.

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

### Version management and package publishing

[semantic-release](https://semantic-release.gitbook.io/semantic-release/) is used as a tool for automated version management and package publishing. See configuration [here](.github/workflows/release.yaml).

### Installation: TODO

1. Oracle Cloud Infrastructure account (free or paid)
2. Deploy OCI KMS
3. 

### Authentication

Authentication method: [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth)

## Architecture

### Immutable infrastructure

To avoid configuration drift and shorten deployment time for newly spun instances, immutable infrastructure is a preferred solution for provisioning machine images. [HashiCorp Packer](https://www.packer.io/) is used as a tool for building them.

### Secrets management

[HashiCorp Vault](https://www.vaultproject.io/) is used as a secrets management solution for the cluster, deployed as an external service, preferably prior to cluster spinning. Contrary to being installed as a cluster service, it prevents chicken-and-egg situation where it needs to use some sensitive data during provisioning, not yet available at that time. [External Secrets Operator](https://external-secrets.io/latest/) automatically generates cluster secrets from the data stored within the vault.

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
