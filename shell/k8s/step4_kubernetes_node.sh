#!/bin/bash
source ./param.sh

if [ ! -d /var/lib/kubelet ]; then
  mkdir -p /var/lib/kubelet
fi
swapoff -a

cat  > "/etc/kubernetes/kubelet.kubeconfig" <<EOF
apiVersion: v1
kind: Config
clusters:
  - cluster:
      server: http://${host}:8080/
    name: local
contexts:
  - context:
      cluster: local
    name: local
current-context: local
EOF

# 配置
export KUBE_LOGTOSTDERR="--logtostderr=true"
export KUBE_LOG_LEVEL="--v=${kubeLogLevel}"
export KUBE_ALLOW_PRIV="--allow-privileged=true"
export KUBE_MASTER="--master=${nginxLoadBalancingHost}:${nginxLoadBalancingPort}"
if [ -z "${nginxLoadBalancingHost}" ]; then
  export KUBE_MASTER="--master=${host}:8080"
fi
## The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
export KUBELET_ADDRESS="--address=${host}"
#
## The port for the info server to serve on
#export KUBELET_PORT="--port=10250"
#
## You may leave this blank to use the actual hostname
export KUBELET_HOSTNAME="--hostname-override=${host}"
#
## location of the api-server已过时
# KUBELET_API_SERVER="--api-servers=http://192.168.10.58:8080"
#
## pod infrastructure container
export KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=registry.access.redhat.com/rhel7/pod-infrastructure:latest"
#
## Add your own!
# --cgroup-driver=systemd 的配置需要跟docker一样
#--kubeconfig=/etc/kubernetes/kubelet.kubeconfig
export KUBELET_ARGS="--kubeconfig=/etc/kubernetes/kubelet.kubeconfig --require-kubeconfig --cgroup-driver=cgroupfs --cluster-dns=10.254.0.2 --experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig --cert-dir=/etc/kubernetes/ssl --cluster-domain=cluster.local --hairpin-mode promiscuous-bridge --serialize-image-pulls=false"

cat > /etc/systemd/system/kubelet.service <<EOF
[Unit]
Description=Kubernetes Kubelet Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/kubelet
ExecStart=/usr/local/bin/kubelet \
            ${KUBE_LOGTOSTDERR} \
            ${KUBE_LOG_LEVEL} \
            ${KUBELET_ADDRESS} \
            ${KUBELET_PORT} \
            ${KUBELET_HOSTNAME} \
            ${KUBE_ALLOW_PRIV} \
            ${KUBELET_POD_INFRA_CONTAINER} \
            ${KUBELET_ARGS}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

## 启动kubelet
systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet

export KUBE_PROXY_ARGS="--bind-address=${host} --hostname-override=${host} --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig --cluster-cidr=${serviceClusterIpRange}"

cat > /etc/systemd/system/kube-proxy.service <<EOF
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/proxy
ExecStart=/usr/local/bin/kube-proxy \
        ${KUBE_LOGTOSTDERR} \
        ${KUBE_LOG_LEVEL} \
        ${KUBE_MASTER} \
        ${KUBE_PROXY_ARGS}
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

## 启动 kube-proxy
systemctl daemon-reload
systemctl enable kube-proxy
systemctl start kube-proxy