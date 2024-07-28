## About

Repository for provisioning [K3s](https://docs.k3s.io/) container orchestration tool, basing
on [always free](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm)
infrastructure resources from Oracle Infrastructure Cloud.

Tool: Terraform  
Cloud provider: Oracle Cloud Infrastructure

## Setup

CLI tools useful when working from local machine:

| Name                                                                                                  | Description                                  |
|-------------------------------------------------------------------------------------------------------|----------------------------------------------|
| [k3s](https://docs.k3s.io/quick-start)                                                                | Container orchestration                      |
| [oci](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm#Quickstart)               | Oracle Cloud Infrastructure cloud provider   |
| [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)          | Infrastructure provisioning, static analysis |
| [tflint](https://github.com/terraform-linters/tflint#installation)                                    | Static analysis                              |
| [trivy](https://aquasecurity.github.io/trivy/latest/getting-started/installation/)                    | Static analysis                              |
| [checkov](https://github.com/bridgecrewio/checkov#getting-started)                                    | Static analysis                              |
| [helm](https://helm.sh/docs/intro/install/)                                                           | Package manager for container orchestration  |
| [packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) | Machine images provisioning                  |

## Repository structure

```
.
├── .github                 # GitHub config files
│   └── workflows           # GitHub Actions config files
├── certificates            # public certificates
├── machine-images          # source files for machine images
├── <module-0>              # source files for Terraform <module-0>
│   └── ...                 # source files
├── README.md
├── ...                     # other dirs/files
```

## Static analysis

### Terraform fmt

- [Template](.github/workflows/terraform-fmt.yaml)
- [Documentation](https://developer.hashicorp.com/terraform/cli/commands/fmt)

### Terraform validate

- [Template](.github/workflows/terraform-validate.yaml)
- [Documentation](https://developer.hashicorp.com/terraform/cli/commands/validate)

### TFLint

- [Template](.github/workflows/tflint.yaml)
- [Documentation](https://github.com/terraform-linters/tflint)

### Trivy

- [Template](.github/workflows/trivy.yaml)
- [Documentation](https://github.com/aquasecurity/trivy)

### Checkov

- [Template](.github/workflows/checkov.yaml)
- [Documentation](https://github.com/bridgecrewio/checkov-action)

### Aggregator of all static analyzers

- [Template](.github/workflows/static-analysis.yaml)
- Includes:
  - [Terraform fmt](#terraform-fmt)
  - [Terraform validate](#terraform-validate)
  - [TFLint](#tflint)
  - [Trivy](#trivy)
  - [Checkov](#checkov)

## Architecture

### Immutable infrastructure

To avoid configuration drift and shorten deployment time for newly spun instances, immutable infrastructure is a
preferred solution for provisioning machine images. [HashiCorp Packer](https://www.packer.io/) is used as a tool for
building them.


## Access to cluster

```
terraform init
terraform workspace list
terraform select default
mkdir -p ~/.kube
terraform output -raw kubeconfig > ~/.kube/config-google-cloud
echo 'export KUBECONFIG=~/.kube/config-google-cloud' >> ~/.bashrc
kubectl get nodes
```
