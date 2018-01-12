#!/bin/bash

docker-compose -f etcd.yml down
docker-compose -f kube-master.yml down
docker-compose -f kube-node.yml down
rm -rf /var/lib/kubelet /srv/etcd /etc/kubernetes /etc/etcd /etc/cni
docker rm -f `docker ps -a | grep kube | awk '{print $1}'`