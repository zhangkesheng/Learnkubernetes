#!/bin/bash
node1=192.168.10.56
node2=192.168.10.57
node3=192.168.10.58
KUBE_API_CLUSTER_IP=172.18.0.1
nodes="${node1},${node2},${node3}"

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
bash 2generate_kubernetes_pem.sh ${nodes} ${KUBE_API_CLUSTER_IP}

echo "distribute the certificate"
scp -r etcd root@${node1}:/etc/etcd
scp -r etcd root@${node2}:/etc/etcd
scp -r etcd root@${node3}:/etc/etcd

scp -r kubernetes root@${node1}:/etc/kubernetes
scp -r kubernetes root@${node2}:/etc/kubernetes
scp -r kubernetes root@${node3}:/etc/kubernetes