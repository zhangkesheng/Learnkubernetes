#!/bin/bash
#param
source ./param.sh

## 部署一个nginx做master的负载均衡
docker pull nginx:alpine
if [ ! -d /srv/nginx/conf.d ]; then
mkdir -p /srv/nginx/conf.d
fi
cat > /srv/nginx/conf.d/k8smaster.conf <<EOF
upstream k8sMaster {
    ${masterHostList}
}
server {
    listen  ${nginxLoadBalancingPort};
    server_name localhost;
    location / {
        proxy_pass http://k8sMaster;
    }
}
EOF
docker run -d --name k8snginx -p ${nginxLoadBalancingPort}:${nginxLoadBalancingPort} --privileged=true \
-v /srv/nginx/conf.d:/etc/nginx/conf.d nginx:alpine