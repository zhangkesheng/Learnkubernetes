#!/bin/bash
source ./param.sh

bash kubectl.sh ${k8sVersion} ${host}

# logging to stderr means we get it in the systemd journal
export KUBE_LOGTOSTDERR="--logtostderr=true"

# journal message level, 0 is debug
export KUBE_LOG_LEVEL="--v=${kubeLogLevel}"

# Should this cluster be allowed to run privileged docker containers
export KUBE_ALLOW_PRIV="--allow-privileged=true"

# How the controller-manager, scheduler, and proxy find the apiserver
#KUBE_MASTER="--master=http://sz-pg-oam-docker-test-001.tendcloud.com:8080"
export KUBE_MASTER="--master=${nginxLoadBalancingHost}:${nginxLoadBalancingPort}"

## The address on the local server to listen to.
#KUBE_API_ADDRESS="--insecure-bind-address=sz-pg-oam-docker-test-001.tendcloud.com"
export KUBE_API_ADDRESS="--insecure-bind-address=0.0.0.0"
#
## The port on the local server to listen on.
export KUBE_API_PORT="--port=8080"
#
## Port minions listen on
export KUBELET_PORT="--kubelet-port=10250"
#
## Comma separated list of nodes in the etcd cluster
export KUBE_ETCD_SERVERS="--etcd-servers=${kubeEtcdServers}"
#
## Address range to use for services
export KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=${serviceClusterIpRange}"
#
## default admission control policies
export KUBE_ADMISSION_CONTROL="--admission-control=ServiceAccount,NamespaceLifecycle,NamespaceExists,LimitRanger,ResourceQuota"
#
## Add your own!
export KUBE_API_ARGS="--authorization-mode=RBAC --runtime-config=rbac.authorization.k8s.io/v1beta1 --kubelet-https=true --experimental-bootstrap-token-auth --token-auth-file=/etc/kubernetes/token.csv --service-node-port-range=30000-32767 --tls-cert-file=/etc/kubernetes/ssl/kubernetes.pem --tls-private-key-file=/etc/kubernetes/ssl/kubernetes-key.pem --client-ca-file=/etc/kubernetes/ssl/ca.pem --service-account-key-file=/etc/kubernetes/ssl/ca-key.pem --etcd-cafile=/etc/kubernetes/ssl/ca.pem --etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem --etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem --enable-swagger-ui=true --apiserver-count=${apiserverCount} --audit-log-maxage=30 --audit-log-maxbackup=3 --audit-log-maxsize=100 --audit-log-path=/var/lib/audit.log --event-ttl=1h"

# 安装 kubernetes server
wget https://dl.k8s.io/${k8sVersion}/kubernetes-server-linux-amd64.tar.gz
tar -xzvf kubernetes-server-linux-amd64.tar.gz
# 将二进制文件拷贝到指定路径
cp -r kubernetes/server/bin/{kube-apiserver,kube-controller-manager,kube-scheduler,kubectl,kube-proxy,kubelet} /usr/local/bin/

# #配置启动kube-apiserver
cat > /etc/systemd/system/kube-apiserver.service <<EOF
[Unit]
Description=Kubernetes API Service
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target
After=etcd.service

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/apiserver
ExecStart=/usr/local/bin/kube-apiserver \
        ${KUBE_LOGTOSTDERR} \
        ${KUBE_LOG_LEVEL} \
        ${KUBE_ETCD_SERVERS} \
        ${KUBE_API_ADDRESS} \
        ${KUBE_API_PORT} \
        ${KUBELET_PORT} \
        ${KUBE_ALLOW_PRIV} \
        ${KUBE_SERVICE_ADDRESSES} \
        ${KUBE_ADMISSION_CONTROL} \
        ${KUBE_API_ARGS}
Restart=on-failure
Type=notify
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
## 启动kube-apiserver
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver

#配置和启动 kube-controller-manager
export KUBE_CONTROLLER_MANAGER_ARGS="--address=127.0.0.1 --service-cluster-ip-range=${serviceClusterIpRange} --cluster-name=kubernetes --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem --cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem  --service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem --root-ca-file=/etc/kubernetes/ssl/ca.pem --leader-elect=true"

cat > /etc/systemd/system/kube-controller-manager.service <<EOF
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/controller-manager
ExecStart=/usr/local/bin/kube-controller-manager \
        ${KUBE_LOGTOSTDERR} \
        ${KUBE_LOG_LEVEL} \
        ${KUBE_MASTER} \
        ${KUBE_CONTROLLER_MANAGER_ARGS}
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

## 启动 kube-controller-manager
systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager

#配置和启动 kube-scheduler
export KUBE_SCHEDULER_ARGS="--leader-elect=true --address=127.0.0.1"

cat > /etc/systemd/system/kube-scheduler.service <<EOF
[Unit]
Description=Kubernetes Scheduler Plugin
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/scheduler
ExecStart=/usr/local/bin/kube-scheduler \
            ${KUBE_LOGTOSTDERR} \
            ${KUBE_LOG_LEVEL} \
            ${KUBE_MASTER} \
            ${KUBE_SCHEDULER_ARGS}
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

## 启动 kube-scheduler
systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler