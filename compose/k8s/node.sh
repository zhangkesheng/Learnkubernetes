#!/bin/bash

cat >daemons/kube-node.yml <<EOF
version: '2'
services:
  kubelet:
    image: bestmike007/hyperkube:v1.9.1
    container_name: kubelet
    restart: always
    privileged: true
    pid: host
    network_mode: host
    volumes:
    - /var/log:/var/log
    - /dev:/dev
    - /run:/run
    - /sys:/sys:ro
    - /sys/fs/cgroup:/sys/fs/cgroup:rw
    - /var/run:/var/run:rw
    - /var/lib/docker/:/var/lib/docker:rw
    - /var/lib/kubelet/:/var/lib/kubelet:shared
    - /etc/kubernetes:/etc/kubernetes:ro
    - /etc/cni:/etc/cni:ro
    - /opt/cni/bin:/opt/cni/local/bin:rw
    command: bash -c "cp /opt/cni/bin/* /opt/cni/local/bin && \
              /usr/local/bin/kubelet \
              --address=0.0.0.0 \
              --cluster-domain=cluster.local \
              --pod-infra-container-image=bestmike007/pause-amd64:3.0 \
              --cgroups-per-qos=True \
              --enforce-node-allocatable= \
              --hostname-override=${NODE_IP} \
              --cluster-dns=${CLUSTER_DNS} \
              --network-plugin=cni \
              --cni-conf-dir=/etc/cni/net.d \
              --cni-bin-dir=/opt/cni/local/bin \
              --resolv-conf=/etc/resolv.conf \
              --allow-privileged=true \
              --cloud-provider= \
              --kubeconfig=/etc/kubernetes/kubecfg-kubelet.yml \
              --require-kubeconfig=True \
              --fail-swap-on=false \
              --eviction-hard='${EVICTION_HARD}'"
  kube-proxy:
    image: bestmike007/hyperkube:v1.9.1
    container_name: kube-proxy
    restart: always
    privileged: true
    network_mode: host
    volumes:
    - /etc/kubernetes:/etc/kubernetes:ro
    command: "/usr/local/bin/kube-proxy \
              --healthz-bind-address=0.0.0.0 \
              --kubeconfig=/etc/kubernetes/kubecfg-proxy.yml \
              --cluster-cidr=${CLUSTER_CIDR} \
              --v=2"
EOF