#!/bin/bash
read -p "Enter server IP separated by 'space' : " nodes


for node in ${nodes[@]}
do
   echo "User entered node :" \"$node\",
done

bash install_cfssl.sh
bash create_ca_pem.sh
bash create_admin_pem.sh
bash create_kubernetes_pem.sh ${nodes[@]}
bash create_kube_proxy_pem.sh
ls -Al *pem
if [ ! -d "/etc/kubernetes/ssl" ]; then
    mkdir -p /etc/kubernetes/ssl
fi
cp *.pem /etc/kubernetes/ssl
