#!/bin/bash

docker-compose -f kube-etcd.yml down && docker-compose -f kube-master.yml up -d
docker-compose -f kube-master.yml down && docker-compose -f kube-master.yml up -d
docker-compose -f kube-node.yml down && docker-compose -f kube-node.yml up -d