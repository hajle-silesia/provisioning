#!/usr/bin/env bash


wait_lb() {
  while true; do
    curl --output /dev/null --silent -k "https://${INTERNAL_LB}:6443"
    if [[ "$?" -eq 0 ]]; then
      break
    fi
    sleep 5
    echo "$(date -uIs): Waiting for internal load balancer availability" >> user-data-output.log
  done
}


initiate_cluster() {
  echo "$(date -uIs): Checking running instances" >> user-data-output.log
  all_running_instances=$(oci compute instance list --compartment-id "${COMPARTMENT_OCID}" --all --sort-by TIMECREATED | jq -r '[.data[] | select(.["lifecycle-state"] == "RUNNING")] | length')
  availability_domain_0_running_instances=$(oci compute instance list --compartment-id "${COMPARTMENT_OCID}" --availability-domain "${AVAILABILITY_DOMAIN}" --sort-by TIMECREATED | jq -r '[.data[] | select(.["lifecycle-state"] == "RUNNING")] | length')

  echo "$(date -uIs): Quantity of all running instances: ${all_running_instances}" >> user-data-output.log
  echo "$(date -uIs): Quantity of availability domain '0' running instances: ${availability_domain_0_running_instances}" >> user-data-output.log

  if [[ "${all_running_instances}" -eq 1 && "${availability_domain_0_running_instances}" -eq 1 ]]; then
    echo "$(date -uIs): First node, initiating cluster" >> user-data-output.log
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" sh -s - server \
      --cluster-init \
      --write-kubeconfig-mode 600 \
      --token "${K3S_TOKEN}" \
      --tls-san "${INTERNAL_LB}"
  else
    wait_lb
    echo "$(date -uIs): Joining cluster" >> user-data-output.log
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${K3S_VERSION}" sh -s - server \
      --server "https://${INTERNAL_LB}:6443" \
      --write-kubeconfig-mode 600 \
      --token "${K3S_TOKEN}" \
      --tls-san "${INTERNAL_LB}"
  fi
}


cd /root
export OCI_CLI_AUTH=instance_principal
export PATH="${PATH}:/root/bin"
