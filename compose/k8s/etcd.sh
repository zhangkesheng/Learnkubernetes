#!/bin/bash

source ./init.sh

cat >daemons/etcd.yml <<EOF
version: '2'
services:
  etcd:
    image: bestmike007/etcd:v3.2.13
    container_name: etcd
    restart: always
    network_mode: host
    volumes:
    - /srv/etcd:/myzd-etcd-${NODE_NAME}.etcd
    - /etc/etcd:/certs:ro
    environment:
      ETCD_NAME: etcd-${NODE_NAME}
      ETCD_INITIAL_ADVERTISE_PEER_URLS: https://${NODE_IP}:2380
      ETCD_LISTEN_PEER_URLS: https://${NODE_IP}:2380
      ETCD_ADVERTISE_CLIENT_URLS: https://${NODE_IP}:2379
      ETCD_LISTEN_CLIENT_URLS: https://${NODE_IP}:2379,https://127.0.0.1:2379
      ETCD_INITIAL_CLUSTER_TOKEN: myzd-etcd-dev-cluster-01
      ETCD_INITIAL_CLUSTER: ${ETCD_INITIAL_CLUSTER}
      ETCD_CLIENT_CERT_AUTH: "true"
      ETCD_TRUSTED_CA_FILE: /certs/etcd-cs-ca.pem
      ETCD_CERT_FILE: /certs/etcd-server.pem
      ETCD_KEY_FILE: /certs/etcd-server-key.pem
      ETCD_PEER_CLIENT_CERT_AUTH: "true"
      ETCD_PEER_TRUSTED_CA_FILE: /certs/etcd-peer-ca.pem
      ETCD_PEER_CERT_FILE: /certs/etcd-peer.pem
      ETCD_PEER_KEY_FILE: /certs/etcd-peer-key.pem
EOF