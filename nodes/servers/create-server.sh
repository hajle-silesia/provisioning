# Ops Agent installation
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# WireGuard installation
apt install -y wireguard

# K3s installation
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${k3s_version}" sh -s - \
--token "${token}" \
--kube-apiserver-arg \
--service-account-issuer="https://hajlesilesia.online" \
--kube-apiserver-arg \
--service-account-jwks-uri="https://hajlesilesia.online/openid/v1/jwks" \
--tls-san "${internal_lb_ip}" \
--tls-san "${external_lb_ip}" \
--datastore-endpoint "postgres://${key_value_store_user}:${key_value_store_password}@${key_value_store_ip}:5432/${key_value_store_name}"
#--node-external-ip="${external_lb_ip}" \
#--flannel-backend=wireguard-native \
#--flannel-external-ip

# K3s configuration
echo "alias k='k3s kubectl'
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
alias d='k3s kubectl config set-context --current --namespace=default'
alias pp='k3s kubectl config set-context --current --namespace=preprod'
alias a='k3s kubectl config set-context --current --namespace=argocd'
alias e='k3s kubectl config set-context --current --namespace=event-streaming'
alias ip='k3s kubectl config set-context --current --namespace=identity-provider'
alias es='k3s kubectl config set-context --current --namespace=external-secrets'" >> /root/.bashrc
mkdir /root/.kube
k3s kubectl config view --raw > /root/.kube/config
chmod 600 /root/.kube/config
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# ArgoCD deployment
k3s kubectl create namespace argocd
k3s kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.6.7/manifests/install.yaml

# Helm installation
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# Application deployment
helm repo add hajle-silesia https://raw.githubusercontent.com/hajle-silesia/cd-config/master/docs
helm repo update
helm upgrade --install hajle-silesia hajle-silesia/helm -n argocd
