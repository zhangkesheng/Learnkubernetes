#!/bin/bash

cat >daemons/kube-master.yml <<EOF
version: '2'
services:
  kube-api:
    image: bestmike007/hyperkube:v1.9.1
    container_name: kube-api
    restart: always
    network_mode: host
    volumes:
    - /etc/kubernetes:/etc/kubernetes:ro
    command: "/usr/local/bin/kube-apiserver \
              --apiserver-count=3 \
              --allow_privileged=true \
              --service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE} \
              --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname \
              --admission-control=ServiceAccount,NamespaceLifecycle,LimitRanger,PersistentVolumeLabel,DefaultStorageClass,ResourceQuota,DefaultTolerationSeconds \
              --runtime-config=batch/v2alpha1 \
              --runtime-config=authentication.k8s.io/v1beta1=true \
              --runtime-config=extensions/v1beta1/podsecuritypolicy=true \
              --storage-backend=etcd3 \
              --etcd-servers=${ETCD_SERVERS} \
              --etcd-cafile=/etc/kubernetes/etcd-cs-ca.pem \
              --etcd-certfile=/etc/kubernetes/etcd-client.pem \
              --etcd-keyfile=/etc/kubernetes/etcd-client-key.pem \
              --client-ca-file=/etc/kubernetes/kube-ca.pem \
              --service-account-key-file=/etc/kubernetes/kube-service-account.key \
              --tls-ca-file=/etc/kubernetes/kube-ca.pem \
              --tls-cert-file=/etc/kubernetes/kube-api.pem \
              --tls-private-key-file=/etc/kubernetes/kube-api-key.pem \
              --authorization-mode=RBAC \
              --v=4"
  kube-controller:
    image: bestmike007/hyperkube:v1.9.1
    container_name: kube-controller
    restart: always
    network_mode: host
    volumes:
    - /etc/kubernetes:/etc/kubernetes:ro
    command: "/usr/local/bin/kube-controller-manager \
              --address=0.0.0.0 \
              --leader-elect=true \
              --kubeconfig=/etc/kubernetes/kubecfg-controller.yml \
              --enable-hostpath-provisioner=false \
              --node-monitor-grace-period=40s \
              --pod-eviction-timeout=5m0s \
              --v=2 \
              --allocate-node-cidrs=true \
#              --cluster-cidr=${CLUSTER_CIDR} \
              --service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE} \
              --service-account-private-key-file=/etc/kubernetes/kube-service-account.key \
              --root-ca-file=/etc/kubernetes/kube-ca.pem \
              --use-service-account-credentials=true"
  kube-scheduler:
    image: bestmike007/hyperkube:v1.9.1
    container_name: kube-scheduler
    restart: always
    network_mode: host
    volumes:
    - /etc/kubernetes:/etc/kubernetes:ro
    command: "/usr/local/bin/kube-scheduler \
              --leader-elect=true \
              --v=2 \
              --kubeconfig=/etc/kubernetes/kubecfg-scheduler.yml \
              --address=0.0.0.0"
EOF