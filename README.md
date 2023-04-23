### About
Infrastructure as Code (IaC) repository for CRUD operations on infrastructure.  

Tool: Terraform  
Cloud provider: Google Cloud

### Requirements
CLI tools needed for infrastructure management from local machine:
- k3s
- gcloud
- terraform

### Access to cluster
```
terraform init
terraform workspace list
terraform select default
mkdir -p ~/.kube
terraform output -raw kubeconfig > ~/.kube/config-google-cloud
echo 'export KUBECONFIG=~/.kube/config-google-cloud' >> ~/.bashrc
kubectl get nodes
```
