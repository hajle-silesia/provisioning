#!/usr/bin/env bash

# Installing packages
apt-get update && apt-get upgrade -y
apt-get install -y \
  firewalld \
  jq
systemctl enable firewalld
systemctl start firewalld

# Configuring firewall
servers_inbound_ports=(
"2379"
"2380"
"6443"
)
for port in "${servers_inbound_ports[@]}"; do
  firewall-cmd --zone=public --add-port="${port}"/tcp --permanent
done

firewall-cmd --reload
firewall-cmd --runtime-to-permanent

# Cluster installation
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" sh -s - server \
  --write-kubeconfig-mode 600 \
  --token "${K3S_TOKEN}"

# Timeout for node joining the cluster
sleep 60

# Removal of machine image builder node
node_name="$(kubectl get node -o json | jq -r '.items[].metadata.name')"
kubectl delete node "${node_name}"
