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

helm repo add bitnami https://charts.bitnami.com/bitnami
# helm install wordpress bitnami/wordpress --set service.type=NodePort --set service.nodePorts.http=32000 --set service.nodePorts.https=32001

mkdir mkdir -p /root/wordpress-chart/templates/

echo 'apiVersion: v2
name: wordpress-chart
description: A simple WordPress Helm chart
version: 0.1.0
appVersion: "6.6.2"' >> /root/wordpress-chart/Chart.yaml

echo 'wordpress:
  image: wordpress:6.6.2-php8.1-apache
  replicaCount: 1
  service:
    type: NodePort
    port: 80
    nodePort: 32000
  resources:
    requests:
      memory: "128Mi"
      cpu: "250m"
  env:
    WORDPRESS_DB_HOST: mysql
    WORDPRESS_DB_USER: wordpress
    WORDPRESS_DB_PASSWORD: wordpresspass
    WORDPRESS_DB_NAME: wordpress

mysql:
  image: mysql:8.0
  replicaCount: 1
  service:
    type: ClusterIP
    port: 3306
  resources:
    requests:
      memory: "128Mi"
      cpu: "250m"
  env:
    MYSQL_ROOT_PASSWORD: rootpassword
    MYSQL_DATABASE: wordpress
    MYSQL_USER: wordpress
    MYSQL_PASSWORD: wordpresspass' >> /root/wordpress-chart/values.yaml

echo 'apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  replicas: {{ .Values.mysql.replicaCount }}
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: {{ .Values.mysql.image }}
        ports:
        - containerPort: 3306
        env:
          - name: MYSQL_ROOT_PASSWORD
            value: {{ .Values.mysql.env.MYSQL_ROOT_PASSWORD }}
          - name: MYSQL_DATABASE
            value: {{ .Values.mysql.env.MYSQL_DATABASE }}
          - name: MYSQL_USER
            value: {{ .Values.mysql.env.MYSQL_USER }}
          - name: MYSQL_PASSWORD
            value: {{ .Values.mysql.env.MYSQL_PASSWORD }}
        resources:
          requests:
            memory: {{ .Values.mysql.resources.requests.memory }}
            cpu: {{ .Values.mysql.resources.requests.cpu }}' >> /root/wordpress-chart/templates/mysql-deployment.yaml

echo 'apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: {{ .Values.mysql.service.type }}
  ports:
    - port: {{ .Values.mysql.service.port }}
      targetPort: 3306
  selector:
    app: mysql' >> /root/wordpress-chart/templates/mysql-service.yaml

echo 'apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: {{ .Values.wordpress.replicaCount }}
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: {{ .Values.wordpress.image }}
        ports:
        - containerPort: 80
        env:
          - name: WORDPRESS_DB_HOST
            value: {{ .Values.wordpress.env.WORDPRESS_DB_HOST }}
          - name: WORDPRESS_DB_USER
            value: {{ .Values.wordpress.env.WORDPRESS_DB_USER }}
          - name: WORDPRESS_DB_PASSWORD
            value: {{ .Values.wordpress.env.WORDPRESS_DB_PASSWORD }}
          - name: WORDPRESS_DB_NAME
            value: {{ .Values.wordpress.env.WORDPRESS_DB_NAME }}
        resources:
          requests:
            memory: {{ .Values.wordpress.resources.requests.memory }}
            cpu: {{ .Values.wordpress.resources.requests.cpu }}' >> /root/wordpress-chart/templates/wordpress-deployment.yaml

echo 'apiVersion: v1
kind: Service
metadata:
  name: wordpress
spec:
  type: {{ .Values.wordpress.service.type }}
  ports:
    - port: {{ .Values.wordpress.service.port }}
      targetPort: 80
      nodePort: {{ .Values.wordpress.service.nodePort }}
  selector:
    app: wordpress' >> /root/wordpress-chart/templates/wordpress-service.yaml

helm install my-release /root/wordpress-chart

echo "Setup is done"