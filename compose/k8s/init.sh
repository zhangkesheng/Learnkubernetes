#!/bin/bash

source ./config.sh

# 获取传入的参数
node=""
while getopts "n:" arg
do
    case $arg in
         n)
            node="$OPTARG"
            ;;
         ?)
            echo "unkonw argument"
            return;
            ;;
    esac
done
if [ -z "${node}" ]; then
    echo "please enter node ip. option -n"
    exit 1
fi
if [ ! -d "/etc/kubernetes" ]; then
    mkdir -p /etc/kubernetes
fi
echo "generate service config"
bash 1generate_service_config.sh ${masterIp}

if [ ! -d "daemons" ]; then
  mkdir daemons
fi
export NODE_NAME=${node}
export NODE_IP=${node}
export ETCD_INITIAL_CLUSTER="etcd-${node1}=https://${node1}:2380,etcd-${node2}=https://${node2}:2380,etcd-${node3}=https://${node3}:2380"
export ETCD_SERVERS="https://${node1}:2379,https://${node2}:2380,https://${node3}:2380"
export SERVICE_CLUSTER_IP_RANGE=${SERVICE_CLUSTER_IP_RANGE}
export CLUSTER_CIDR=${CLUSTER_CIDR}
export EVICTION_HARD=${EVICTION_HARD}

export CLUSTER_DNS=${CLUSTER_DNS}
export CLUSTER_DOMAIN=${CLUSTER_DOMAIN}
export KUBEDNS_IMAGE=${KUBEDNS_IMAGE}
export DNSMASQ_IMAGE=${DNSMASQ_IMAGE}
export KUBEDNS_SIDECAR_IMAGE=${KUBEDNS_SIDECAR_IMAGE}
export KUBEDNS_AUTOSCALER_IMAGE=${KUBEDNS_AUTOSCALER_IMAGE}

bash etcd.sh
bash master.sh
bash node.sh
bash dns.sh

ufw allow proto tcp from 192.168.32.14 to any port 6783
ufw allow proto tcp from 192.168.32.15 to any port 6783
ufw allow proto tcp from 192.168.32.16 to any port 6783
ufw allow proto udp from 192.168.32.14 to any port 6783
ufw allow proto udp from 192.168.32.15 to any port 6783
ufw allow proto udp from 192.168.32.16 to any port 6783
ufw allow proto udp from 192.168.32.14 to any port 6784
ufw allow proto udp from 192.168.32.15 to any port 6784
ufw allow proto udp from 192.168.32.16 to any port 6784

#for arg in `find ~/k8s-configurations/projects -name "*.yaml"`
#do
#    kubectl apply -f ${arg}
#done