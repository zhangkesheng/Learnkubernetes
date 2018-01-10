#!/bin/bash

source ./config.sh

# 获取传入的参数
node=node1
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

if [ ! -d "/etcd/kubernetes" ]; then
    mkdir p /etcd/kubernetes
fi
echo "generate service config"
bash 3generate_service_config.sh masterIp

mkdir daemons
NODE_NAME=${node}
NODE_IP=${node}
ETCD_INITIAL_CLUSTER="etcd-${node1}:https://${node1}:2380,etcd-${node2}:https://${node2}:2380,etcd-${node3}:https://${node3}:2380"
bash etcd.sh

