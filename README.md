## About
Repository for provisioning infrastructure resources.  

Tool: Terraform  
Cloud provider: Oracle Cloud Infrastructure

## Requirements
CLI tools useful for provisioning infrastructure from local machine:
- k3s
- oci
- terraform
- helm

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
