#!/bin/bash
source ./config.sh

cat > docker-compose.yml <<EOF
version: '2'
services:
  etcd:
    image: bestmike007/etcd:v3.2.11
    restart: always
    command: "/usr/local/bin/etcd \
            --name=etcd-${NODENAME} \
            --cert-file=/etc/etcd/ssl/etcd.pem \
            --key-file=/etc/etcd/ssl/etcd-key.pem \
            --peer-cert-file=/etc/etcd/ssl/etcd.pem \
            --peer-key-file=/etc/etcd/ssl/etcd-key.pem \
            --trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
            --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
            --initial-advertise-peer-urls=https://${NODE_IP}:2380 \
            --listen-peer-urls=https://${NODE_IP}:2380 \
            --listen-client-urls=https://${NODE_IP}:2379,http://127.0.0.1:2379 \
            --advertise-client-urls=https://${NODE_IP}${NODE_IP}:2379 \
            --initial-cluster-token=etcd-cluster \
            --initial-cluster=${ETCD_NODES} \
            --initial-cluster-state=new \
            --data-dir=/var/lib/etcd"
    volumes:
      - /var/lib/etcd:/etcd-data
    ports:
      - '2379:2379'
      - '2380:2380'
EOF