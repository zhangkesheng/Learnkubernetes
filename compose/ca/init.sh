#!/bin/bash
nodes=192.168.10.56,192.168.10.57,192.168.10.58
for node in ${nodes//,/ }
do
   echo "Use node :" \"${node}\",
done

bash install_cfssl.sh
bash 1create_ca_pem.sh
bash 10create_etcd_pem.sh
bash 2create_kube_api_pem.sh ${nodes//,/ }
bash 3create_kube_controller_manager_pem.sh
bash 4create_kube_scheduler_pem.sh
bash 5create_kube_proxy_pem.sh
bash 6create_kube_node_pem.sh
ls -Al *pem
if [ ! -d "/etc/kubernetes/ssl" ]; then
    mkdir -p /etc/kubernetes/ssl
fi
cp *.pem /etc/kubernetes/ssl
