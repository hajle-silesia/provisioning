## About

Repository for provisioning [K3s](https://docs.k3s.io/) container orchestration tool, basing on [always free](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm) infrastructure resources from Oracle Infrastructure Cloud.

## Setup

### CLI tools useful when working from local machine

| Name                                                                                                  | Description                                       |
|-------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| [k3s](https://docs.k3s.io/quick-start)                                                                | Container orchestration                           |
| [oci](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm#Quickstart)               | Oracle Cloud Infrastructure cloud provider        |
| [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)          | Infrastructure provisioning, static analysis      |
| [mise](https://mise.jdx.dev/getting-started.html)                                                     | Tool version manager                              |
| [atmos](https://atmos.tools/install/)                                                                 | Cloud architecture framework for native Terraform |
| [tflint](https://github.com/terraform-linters/tflint#installation)                                    | Static analysis                                   |
| [trivy](https://aquasecurity.github.io/trivy/latest/getting-started/installation/)                    | Static analysis                                   |
| [checkov](https://github.com/bridgecrewio/checkov#getting-started)                                    | Static analysis                                   |
| [pre-commit](https://pre-commit.com/)                                                                 | Managing pre-commit hooks                         |
| [helm](https://helm.sh/docs/intro/install/)                                                           | Package manager for container orchestration       |
| [packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) | Machine images provisioning                       |

### Installation: TODO

1. Oracle Cloud Infrastructure account (free or paid)
2. Deploy OCI KMS
3. 

## Repository structure

General overview of the repository structure. Not all files are listed.
```
.
├── .github                 # GitHub config files
│   ├── workflows           # GitHub Actions config files
│   └── renovate.json       # Renovate config
├── certificates            # certificates
├── components              # Terraform root modules
├── machine-images          # source files for machine images
├── modules                 # Terraform modules
│   ├── <module-0>          # source files for Terraform <module-0>
│   └── ...                 # other modules
├── stacks                  # Atmos stacks
├── .mise.toml              # Mise config file
├── .pre-commit-config.yaml # pre-commit config file
├── .trivyignore.yaml       # Trivy config file
├── atmos.yaml              # Atmos config file
├── Dockerfile              # local development image config
├── README.md
```

### Authentication

Authentication method: [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth)

## Static analysis

### Local

#### Terraform fmt pre-commit hook

- [Configuration](.pre-commit-config.yaml)
- [Documentation](https://github.com/antonbabenko/pre-commit-terraform)

### Remote

#### Terraform fmt

- [Template](.github/workflows/terraform-fmt.yaml)
- [Documentation](https://developer.hashicorp.com/terraform/cli/commands/fmt)

#### Terraform validate

- [Template](.github/workflows/terraform-validate.yaml)
- [Documentation](https://developer.hashicorp.com/terraform/cli/commands/validate)

#### TFLint

- [Template](.github/workflows/tflint.yaml)
- [Documentation](https://github.com/terraform-linters/tflint)

#### Trivy

- [Template](.github/workflows/trivy.yaml)
- [Documentation](https://github.com/aquasecurity/trivy)

#### Checkov

- [Template](.github/workflows/checkov.yaml)
- [Documentation](https://github.com/bridgecrewio/checkov-action)

#### Aggregator of all static analyzers

- [Template](.github/workflows/static-analysis.yaml)
- Includes:
  - [Terraform fmt](#terraform-fmt)
  - [Terraform validate](#terraform-validate)
  - [TFLint](#tflint)
  - [Trivy](#trivy)
  - [Checkov](#checkov)

## Architecture

### Immutable infrastructure

To avoid configuration drift and shorten deployment time for newly spun instances, immutable infrastructure is a preferred solution for provisioning machine images. [HashiCorp Packer](https://www.packer.io/) is used as a tool for building them.

### Secrets management

[HashiCorp Vault](https://www.vaultproject.io/) is used as a secrets management solution for the cluster, deployed as an external service, preferably prior to cluster spinning. Contrary to being installed as a cluster service, it prevents chicken and egg situation where it needs to use some sensitive data during provisioning, not yet available at that time. [External Secrets Operator](https://external-secrets.io/latest/) automatically generates cluster secrets from the data stored within the vault.

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
