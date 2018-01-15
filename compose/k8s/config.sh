#!/bin/bash
node1=192.168.10.56
node2=192.168.10.57
node3=192.168.10.58
masterIp=192.168.10.56
SERVICE_CLUSTER_IP_RANGE=172.18.0.0/18
CLUSTER_CIDR=172.18.64.0/18
CLUSTER_DNS=172.18.0.3
EVICTION_HARD="memory.available<10%,nodefs.available<10%"

CLUSTER_DOMAIN="cluster.local"
KUBEDNS_IMAGE="bestmike007/k8s-dns-kube-dns-amd64:1.14.5"
DNSMASQ_IMAGE="bestmike007/k8s-dns-dnsmasq-nanny-amd64:1.14.5"
KUBEDNS_SIDECAR_IMAGE="bestmike007/k8s-dns-sidecar-amd64:1.14.5"
KUBEDNS_AUTOSCALER_IMAGE="bestmike007/cluster-proportional-autoscaler-amd64:1.0.0"