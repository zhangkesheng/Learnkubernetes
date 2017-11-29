#!/bin/bash
# params
echo "set params"
host=192.168.10.56
clusters=192.168.10.56,192.168.10.57,192.168.10.58
k8sVersion=v1.8.4
etcdName=infra1
etcdInitialCluster=infra1=https://192.168.10.56:2380,infra2=https://192.168.10.57:2380,infra3=https://192.168.10.58:2380

# export
echo "export env"
## 翻墙
export http_proxy=http://192.168.32.10:6780
export https_proxy=http://192.168.32.10:6780
export no_proxy=".aliyun.com,.aliyuncs.com,.daocloud.io,localhost,$host"
echo "http_proxy: $http_proxy"
echo "https_proxy: $https_proxy"
echo "no_proxy: $no_proxy"
## Etcd
# [member]
export ETCD_NAME=$etcdName
export ETCD_DATA_DIR="/var/lib/etcd"
export ETCD_LISTEN_PEER_URLS="https://$host:2380"
export ETCD_LISTEN_CLIENT_URLS="https://$host:2379,https://$host:4001"
#[cluster]
export ETCD_INITIAL_ADVERTISE_PEER_URLS="https://$host:2380"
export ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
export ETCD_ADVERTISE_CLIENT_URLS="https://$host:2379,https://$host:4001"

#bash
echo "run shell"
bash prepare.sh $clusters
bash kubectl.sh $k8sVersion $host
bash etcd.sh $etcdInitialCluster
