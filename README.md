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

1. Create Oracle Cloud Infrastructure account [here](https://www.oracle.com/cloud/free/).
1. Upgrade Free Tier account to a paid account. Paid accounts precede Free Tier accounts when it comes to resources (especially instances) provisioning by OCI. For Free Tier accounts it can take hours.
   1.  Log into Oracle Cloud Infrastructure Console. 
   1.  Go to "Billing & Cost Management" in navigation menu. 
   1.  Go to "Upgrade and Manage Payment" under "Billing" section. 
   1.  In "Pay As You Go" section, click "Upgrade your account" button. 
   1.  Follow instructions for payment method. 
   1.  Account upgrade process should start.
1. [Optional] Create budgets to control costs. Paid account billing charges specified payment method according to the resource tier type.
   1. Log into Oracle Cloud Infrastructure Console. 
   1. Go to "Billing & Cost Management" in navigation menu.
   1. Go to "Budgets" under "Cost Management" section. 
   1. Click "Create Budget" and set preferred budget and alerts.
1. Generate API key for your user as described [here](https://docs.oracle.com/en-us/iaas/Content/terraform/configuring.htm#APIKeyAuth).
1. Create S3-compatible backend as described [here](https://docs.oracle.com/en-us/iaas/Content/terraform/object-storage-state.htm#s3).
1. Generate customer secret key for your profile as described [here](https://docs.oracle.com/en-us/iaas/Content/terraform/object-storage-state.htm#auth).

#### Day-1

Atmos workflows are used for cold starts. See configuration [here](stacks/workflows). Execute these commands for full deployment:

```shell
atmos workflow apply-all-components -f foundation
atmos terraform apply vault -s plat-fra-prod # Secrets needed for provisioning platform
atmos terraform apply vcn -s plat-fra-prod # Networking needed for golden image CI

# Create vault secrets here (see Secrets management section) as they are needed for provisioning platform environment
# Run golden image CI workflow as it's needed to create cluster nodes

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

OCI Vault is used as a secrets management solution for the cluster. Dedicated secret (see instance component) stores the cluster initialization flag, useful for server nodes during cold start (spinning new cluster). [External Secrets Operator](https://external-secrets.io/latest/) generates cluster secrets from the data stored within the vault as described [here](https://external-secrets.io/latest/provider/oracle-vault/).

| Name              | Content                                                                                                                     | Description           |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------|-----------------------|
| msg-queuing       | <pre>{<br>&nbsp; "CA_CERT": "\<ca-cert>",<br>&nbsp; "TLS_CERT": "\<tls-cert>",<br>&nbsp; "TLS_KEY": "\<tls-key>"<br>}</pre> | Domain's certificate. |


### DNS

#### Private

Hostnames are used for network resources to allow certificate usage with the name defined as described [here](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/dns.htm#About). Certificate is used in the container orchestration cluster.

#### Public

In order to connect the provisioned hosted zone to the purchased domain, add the NS records to the domain registrar. Usually, these need to be added manually to the registered domain. See delegation example [here](https://pomoc.home.pl/baza-wiedzy/jak-wydelegowac-domene-z-home-pl-na-serwery-dns-zewnetrznego-operatora).

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
