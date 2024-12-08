#!/bin/bash
yum -y update && yum -y upgrade

echo 'kubelet-arg:
  - "fail-swap-on=false"' >> /etc/rancher/k3s/config.yaml

curl -sL get.k3s.io | sh -s - server --kubelet-arg=feature-gates=NodeSwap=true
chmod 644 /etc/rancher/k3s/k3s.yaml

sudo dd if=/dev/zero of=/swapfile bs=128M count=16
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s

SWAP_ENTRY="/swapfile swap swap defaults 0 0"

if ! grep -qF "$SWAP_ENTRY" /etc/fstab; then
    echo "$SWAP_ENTRY" | sudo tee -a /etc/fstab
    echo "Swap entry added to /etc/fstab."
else
    echo "Swap entry already exists in /etc/fstab."
fi

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
source ~/.bashrc

echo "Setup is done"