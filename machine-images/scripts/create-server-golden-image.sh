#!/usr/bin/env bash


function update_and_upgrade_packages() {
  apt-get update && apt-get upgrade -y
}


function install_packages() {
  apt-get install -y \
    firewalld \
    jq
}


function install_cloud_provider_cli() {
  curl -LO https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh
  chmod +x install.sh
  ./install.sh --accept-all-defaults
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
  firewall_services=(
    "ufw"
    "iptables"
    "ip6tables"
    "nftables"
  )

  for service in "${firewall_services[@]}"; do
    systemctl disable "${service}"
    systemctl mask "${service}"
  done
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


function set_per_instance_script() {
  cp user-data.sh /var/lib/cloud/scripts/per-instance/user-data.sh
  chmod 744 /var/lib/cloud/scripts/per-instance/user-data.sh

  {
    echo "K3S_VERSION=${K3S_VERSION}"
    echo "K3S_TOKEN=${K3S_TOKEN}"
    echo "INTERNAL_LB=${INTERNAL_LB}"
    echo "COMPARTMENT_OCID=${COMPARTMENT_OCID}"
    echo "AVAILABILITY_DOMAIN=${AVAILABILITY_DOMAIN}"

    echo "main"
  } >> /var/lib/cloud/scripts/per-instance/user-data.sh
}


cloud-init status --wait
update_and_upgrade_packages
install_packages
install_cloud_provider_cli
install_package_manager_for_container_orchestration_tool
disable_firewalls
configure_firewall
set_per_instance_script
rm /home/ubuntu/create-server-golden-image.sh
rm /home/ubuntu/user-data.sh
