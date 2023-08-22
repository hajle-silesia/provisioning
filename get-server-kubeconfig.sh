#!/bin/bash

eval "$(jq -r '@sh "SERVER_IP=\(.server_ip)"')"
server_kubeconfig="$(ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/id_ed25519 mtweeman@$SERVER_IP cat /etc/rancher/k3s/k3s.yaml)"
localhost_ip="127.0.0.1"
jq -n --arg command "${server_kubeconfig//"$localhost_ip"/"$SERVER_IP"}" '{"kubeconfig":$command}'
