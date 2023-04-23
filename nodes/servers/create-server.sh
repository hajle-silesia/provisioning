curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.25.6+k3s1" sh -s - \
--write-kubeconfig-mode 644 \
--token "${token}"
touch /home/mtweeman/startup-script-finished && date > $_
