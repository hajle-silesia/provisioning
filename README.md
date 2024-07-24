## About

Repository for provisioning infrastructure resources.

Tool: Terraform  
Cloud provider: Oracle Cloud Infrastructure

## Requirements

CLI tools useful when working from local machine:

- k3s
- oci
- terraform
- tflint
- helm
- packer

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

### Aggregator of all static analyzers

- [Template](.github/workflows/static-analysis.yaml)
- Includes:
   - [Terraform fmt](#terraform-fmt)
   - [Terraform validate](#terraform-validate)
   - [TFLint](#tflint)

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
