#!/bin/bash
SERVER_IP=$1
cat >/etc/kubernetes/kubecfg-controller.yml <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    api-version: v1
    certificate-authority: /etc/kubernetes/kube-ca.pem
    server: "https://${SERVER_IP}:6443"
  name: "local"
contexts:
- context:
    cluster: "local"
    user: "kube-controller"
  name: "Default"
current-context: "Default"
users:
- name: "kube-controller"
  user:
    client-certificate: /etc/kubernetes/kube-controller.pem
    client-key: /etc/kubernetes/kube-controller-key.pem
EOF

cat >/etc/kubernetes/kubecfg-scheduler.yml <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    api-version: v1
    certificate-authority: /etc/kubernetes/kube-ca.pem
    server: "https://${SERVER_IP}:6443"
  name: "local"
contexts:
- context:
    cluster: "local"
    user: "kube-scheduler"
  name: "Default"
current-context: "Default"
users:
- name: "kube-scheduler"
  user:
    client-certificate: /etc/kubernetes/kube-scheduler.pem
    client-key: /etc/kubernetes/kube-scheduler-key.pem
EOF

cat >/etc/kubernetes/kubecfg-proxy.yml <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    api-version: v1
    certificate-authority: /etc/kubernetes/kube-ca.pem
    server: "https://${SERVER_IP}:6443"
  name: "local"
contexts:
- context:
    cluster: "local"
    user: "kube-proxy"
  name: "Default"
current-context: "Default"
users:
- name: "kube-proxy"
  user:
    client-certificate: /etc/kubernetes/kube-proxy.pem
    client-key: /etc/kubernetes/kube-proxy-key.pem
EOF

cat >/etc/kubernetes/kubecfg-kubelet.yml <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    api-version: v1
    certificate-authority: /etc/kubernetes/kube-ca.pem
    server: "https://${SERVER_IP}:6443"
  name: "local"
contexts:
- context:
    cluster: "local"
    user: "kubelet"
  name: "Default"
current-context: "Default"
users:
- name: "kubelet"
  user:
    client-certificate: /etc/kubernetes/kubelet.pem
    client-key: /etc/kubernetes/kubelet-key.pem
EOF