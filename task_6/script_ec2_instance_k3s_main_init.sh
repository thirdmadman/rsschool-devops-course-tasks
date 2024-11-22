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

kubectl create ns jenkins

echo 'apiVersion: v1
kind: PersistentVolume
metadata:
  name: jenkins-pv
  namespace: jenkins
spec:
  storageClassName: jenkins-pv
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 4Gi
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/jenkins-volume/

---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: jenkins-pv
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer' >> /root/jenkins-volume.yaml

mkdir -p /data/jenkins-volume/
kubectl apply -f /root/jenkins-volume.yaml
sudo chown -R 1000:1000 /data/jenkins-volume

echo '---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: jenkins
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: jenkins
rules:
- apiGroups:
  - "*"
  resources:
  - statefulsets
  - services
  - replicationcontrollers
  - replicasets
  - podtemplates
  - podsecuritypolicies
  - pods
  - pods/log
  - pods/exec
  - podpreset
  - poddisruptionbudget
  - persistentvolumes
  - persistentvolumeclaims
  - jobs
  - endpoints
  - deployments
  - deployments/scale
  - daemonsets
  - cronjobs
  - configmaps
  - namespaces
  - events
  - secrets
  verbs:
  - create
  - get
  - watch
  - delete
  - list
  - patch
  - update
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
  - list
  - watch
  - update
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: jenkins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: jenkins
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: system:serviceaccounts:jenkins' >> /root/jenkins-sa.yaml

kubectl apply -f /root/jenkins-sa.yaml

curl https://raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/values.yaml >> /root/jenkins-values.yaml

sed -i -e 's/  size: "8Gi"/  size: "4Gi"/g' /root/jenkins-values.yaml
sed -i -e 's/  nodePort:/  nodePort: 32000/g' /root/jenkins-values.yaml
sed -i -e 's/  storageClass:/  storageClass: jenkins-pv/g' /root/jenkins-values.yaml
sed -i -e ':a;N;$!ba;s/name should be created\n  create: true/name should be created\n  create: false/g' /root/jenkins-values.yaml
sed -i -e ':a;N;$!ba;s/access-controlled resources\n  name:/access-controlled resources\n  name: jenkins/g' /root/jenkins-values.yaml

helm repo add jenkinsci https://charts.jenkins.io && helm repo update

chart=jenkinsci/jenkins
helm install jenkins -n jenkins -f /root/jenkins-values.yaml $chart

kubectl patch svc jenkins -n jenkins -p '{"spec": {"type": "NodePort", "ports": [{"port": 8080, "nodePort": 32000}]}}'

jsonpath="{.data.jenkins-admin-password}"
secret=$(kubectl get secret -n jenkins jenkins -o jsonpath=$jsonpath)
echo "Jenkins password:"
echo $(echo $secret | base64 --decode)

echo "Setup is done"