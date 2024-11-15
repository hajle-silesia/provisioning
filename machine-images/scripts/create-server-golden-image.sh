#!/usr/bin/env bash


function update_and_upgrade_packages() {
  apt-get update && apt-get upgrade -y
}


function install_packages() {
  apt-get install -y \
    jq
}


function install_cloud_provider_cli() {
  curl -LO https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh
  chmod +x install.sh
  ./install.sh --accept-all-defaults --oci-cli-version 3.46.0
  rm -f install.sh
}


function install_package_manager_for_container_orchestration_tool() {
  curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
  apt-get install -y \
    apt-transport-https
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
  apt-get update
  apt-get install -y \
    helm
}


function disable_firewalls() {
  netfilter-persistent stop
  netfilter-persistent flush

  systemctl stop netfilter-persistent
  systemctl disable netfilter-persistent
  systemctl mask netfilter-persistent
}


function configure_firewall() {
  systemctl enable firewalld
  systemctl start firewalld

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
}


function set_user_data_script() {
  cp user-data.sh /root/user-data.sh
}


cloud-init status --wait
update_and_upgrade_packages
install_packages
install_cloud_provider_cli
install_package_manager_for_container_orchestration_tool
disable_firewalls
#configure_firewall
set_user_data_script
rm /home/ubuntu/create-server-golden-image.sh
rm /home/ubuntu/user-data.sh
