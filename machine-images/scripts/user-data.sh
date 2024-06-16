#!/usr/bin/env bash


function main() {
  USER_DATA_OUTPUT_LOG="user-data-output.log"
  
  echo "$(date -uIs): Checking running instances" >> "${USER_DATA_OUTPUT_LOG}"
  all_running_instances=$(oci compute instance list --compartment-id "${COMPARTMENT_OCID}" --all --sort-by TIMECREATED | jq -r '[.data[] | select(.["lifecycle-state"] == "RUNNING")] | length')
  availability_domain_0_running_instances=$(oci compute instance list --compartment-id "${COMPARTMENT_OCID}" --availability-domain "${AVAILABILITY_DOMAIN}" --sort-by TIMECREATED | jq -r '[.data[] | select(.["lifecycle-state"] == "RUNNING")] | length')
  echo "$(date -uIs): Quantity of all running instances: ${all_running_instances}" >> "${USER_DATA_OUTPUT_LOG}"
  echo "$(date -uIs): Quantity of availability domain '0' running instances: ${availability_domain_0_running_instances}" >> "${USER_DATA_OUTPUT_LOG}"

  if [[ "${all_running_instances}" -eq 1 && "${availability_domain_0_running_instances}" -eq 1 ]]; then
    initiate_cluster
  else
    wait_lb
    join_cluster
    delete_unready_nodes
  fi
}


function initiate_cluster() {
  echo "$(date -uIs): First node, initiating cluster" >> "${USER_DATA_OUTPUT_LOG}"
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" sh -s - server \
    --cluster-init \
    --write-kubeconfig-mode 600 \
    --token "${K3S_TOKEN}" \
    --tls-san "${INTERNAL_LB}"
}


function wait_lb() {
  while true; do
    curl --output /dev/null --silent -k "https://${INTERNAL_LB}:6443"
    if [[ "$?" -eq 0 ]]; then
      break
    fi
    sleep 5
    echo "$(date -uIs): Waiting for internal load balancer availability" >> "${USER_DATA_OUTPUT_LOG}"
  done
}


function join_cluster() {
  echo "$(date -uIs): Joining cluster" >> "${USER_DATA_OUTPUT_LOG}"
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" sh -s - server \
    --server "https://${INTERNAL_LB}:6443" \
    --write-kubeconfig-mode 600 \
    --token "${K3S_TOKEN}" \
    --tls-san "${INTERNAL_LB}"
}


function delete_unready_nodes() {
  echo "$(date -uIs): Deleting unready nodes" >> "${USER_DATA_OUTPUT_LOG}"
  unready_nodes=$(kubectl get nodes --no-headers | grep "NotReady" | awk '{print $1}')

  for node in ${unready_nodes}; do
    echo "$(date -uIs): Deleting node ${node}" >> "${USER_DATA_OUTPUT_LOG}"
    kubectl delete node "${node}"
    echo "$(date -uIs): Deleted node ${node}" >> "${USER_DATA_OUTPUT_LOG}"
  done
}


cd /root
export OCI_CLI_AUTH=instance_principal
export PATH="${PATH}:/root/bin"
