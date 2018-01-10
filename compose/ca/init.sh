#!/bin/bash

nodes=192.168.10.56,192.168.10.57,192.168.10.58

for node in ${nodes//,/ }
do
   echo "Use node :" \"${node}\",
done

echo "set docker daemon config"
bash docker_daemon_config.sh

echo "install cfssl cfssljson cfssl-certinfo"
bash install_cfssl.sh

echo "generate config"
bash 0generate_ca_config.sh

echo "generate etcd cerificates"
bash 1generate_etcd_pem.sh ${nodes}

echo "generate kubernetes cerificates"
bash 2generate_kubernetes_pem.sh ${nodes} "172.18.0.1"
