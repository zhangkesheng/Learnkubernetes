#!/bin/bash
node1=192.168.10.56
node2=192.168.10.57
node3=192.168.10.58
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

NODENAME=${node1}
NODE_IP=${node1}
ETCD_NODES="etcd-${node1}:https://${node1}:2380,etcd-${node2}:https://${node2}:2380,etcd-${node3}:https://${node3}:2380"
./deploy.sh

