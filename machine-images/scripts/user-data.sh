#!/usr/bin/env bash

LOGFILE="/root/user-data.log"
set -eo pipefail
exec 3>&1 4>&2 1>"${LOGFILE}" 2>&1
trap "echo 'ERROR: An error occurred during execution, check log ${LOGFILE} for details.' >&3" ERR
trap '{ set +x; } 2>/dev/null; echo -n "[$(date -uIs)] "; set -x' DEBUG


function main() {
  get_cluster_initiated_flag "${VAULT_NAME}" "${SECRET_NAME}" # "plat-fra-prod-vault" "cluster-initiated"

  if [[ "${CLUSTER_INITIATED}" == "false" ]]; then
    set_cluster_initiated_flag
    initiate_cluster
    set_env_variables
    deploy_container_orchestration_cd_tool
    deploy_business_application
    remove_cluster_initiated_flag_deprecated_versions
  else
    wait_lb
    join_cluster
    delete_unready_nodes
    set_env_variables
  fi
}


function get_cluster_initiated_flag() {
  local vault_name=$1
  local secret_name=$2
  local vault_id

  vault_id=$(oci kms management vault list \
    --compartment-id "${COMPARTMENT_OCID}" \
    --all | jq -r --arg vault_name "${vault_name}" '.data[] | select(.["display-name"] == $vault_name) | .id')
  SECRET_ID=$(oci vault secret list \
    --compartment-id "${COMPARTMENT_OCID}" \
    --name "${secret_name}" \
    --vault-id "${vault_id}" | jq -r '.data[].id')
  CLUSTER_INITIATED=$(oci secrets secret-bundle get \
    --secret-id "${SECRET_ID}" | jq -r '.data."secret-bundle-content".content' | base64 -d)
}


function set_cluster_initiated_flag() {
  oci vault secret update-base64 \
    --secret-id "${SECRET_ID}" \
    --secret-content-content "dHJ1ZQ==" # Base64 encoded "true"
}


function initiate_cluster() {
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" sh -s - server \
    --cluster-init \
    --write-kubeconfig-mode 600 \
    --token "${K3S_TOKEN}" \
    --tls-san "${INTERNAL_LB}" \
    --tls-san "${EXTERNAL_LB}"
}


function set_env_variables() {
  echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> .bashrc

  . .bashrc
}


function deploy_container_orchestration_cd_tool() {
  k3s kubectl create namespace argocd
  curl -sSfL https://raw.githubusercontent.com/argoproj/argo-cd/v2.11.3/manifests/install.yaml | k3s kubectl apply -n argocd -f -
}


function deploy_business_application() {
  helm repo add hajle-silesia https://raw.githubusercontent.com/hajle-silesia/container-orchestration-cd-config/master/docs
  helm repo update
  helm upgrade --install hajle-silesia hajle-silesia/helm -n argocd
}


function remove_cluster_initiated_flag_deprecated_versions() {
  deprecated_versions=$(oci secrets secret-bundle-version list-versions \
    --secret-id "${SECRET_ID}" \
    --all | jq -r '.data[] | select(.stages[] == "DEPRECATED") | select(."time-of-deletion" == null) | ."version-number"')
  for deprecated_version in "${deprecated_versions[@]}"; do
    oci vault secret-version schedule-deletion \
      --secret-id "${SECRET_ID}" \
      --time-of-deletion $(date -uIs -d "1 day 1 minute") \
      --secret-version-number "${deprecated_version}"
  done
}


function wait_lb() {
  while true; do
    curl --output /dev/null --silent -k "https://${INTERNAL_LB}:6443"
    if [[ "$?" -eq 0 ]]; then
      break
    fi
    sleep 5
  done
}


function join_cluster() {
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" sh -s - server \
    --server "https://${INTERNAL_LB}:6443" \
    --write-kubeconfig-mode 600 \
    --token "${K3S_TOKEN}"
}


function delete_unready_nodes() {
  hostname="$(hostname)"
  unready_nodes=$(kubectl get nodes --no-headers | grep "NotReady" | awk '{print $1}')

  for node in ${unready_nodes}; do
    if [[ "${node}" != "${hostname}" ]]; then
      kubectl delete node "${node}"
    fi
  done
}


export OCI_CLI_AUTH=instance_principal
PATH="${PATH}:/root/bin"
main
