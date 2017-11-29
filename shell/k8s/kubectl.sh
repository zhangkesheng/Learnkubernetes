#!/bin/bash
source ./param.sh

# 下载kubectl
echo "k8sVersion: $k8sVersion";
echo "host: $host"
wget "https://dl.k8s.io/$k8sVersion/kubernetes-client-linux-amd64.tar.gz"
tar -xzvf kubernetes-client-linux-amd64.tar.gz
cp kubernetes/client/bin/kube* /usr/bin/
chmod a+x /usr/bin/kube*
# 创建kubeconfig文件
## 创建TLS Bootstrapping Token
# 如果是master就创建token
if [ ${isMaster} ]; then
export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom|od -An -t x|tr -d ' ')
cat > /etc/kubernetes/token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF
fi

## 创建 kubelet bootstrapping kubeconfig 文件
export KUBE_APISERVER="https://$host:6443"
# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=/etc/kubernetes/bootstrap.kubeconfig

# 设置客户端认证参数
kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=/etc/kubernetes/bootstrap.kubeconfig

# 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=/etc/kubernetes/bootstrap.kubeconfig

# 设置默认上下文
kubectl config use-context default --kubeconfig=/etc/kubernetes/bootstrap.kubeconfig

## 创建 kube-proxy kubeconfig 文件
# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig
# 设置客户端认证参数
kubectl config set-credentials kube-proxy \
  --client-certificate=/etc/kubernetes/ssl/kube-proxy.pem \
  --client-key=/etc/kubernetes/ssl/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig
# 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig
# 设置默认上下文
kubectl config use-context default --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig
