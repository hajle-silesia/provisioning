## About
Repository for provisioning infrastructure resources.  

Tool: Terraform  
Cloud provider: Google Cloud

## Requirements
CLI tools useful for provisioning infrastructure from local machine:
- k3s
- gcloud
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
