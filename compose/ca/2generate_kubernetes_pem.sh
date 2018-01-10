#!/bin/bash
MASTER_IPS=$1
KUBERNETES_SERVICE_IP=$2
# Generate CA certs for kubernetes
cat >kubernetes-ca-csr.json <<EOF
{
    "CN": "MYZD Kubernetes CA",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "Shanghai",
            "L": "Shanghai",
            "O": "MYZD",
            "OU": "System"
        }
    ],
    "CA": { "Expiry": "876000h" }
}
EOF
cfssl gencert -initca kubernetes-ca-csr.json | cfssljson -bare kube-ca
# Generate service account rsa key pair
openssl genrsa -out kube-service-account.key 4096

cat >kube-admin-csr.json <<EOF
{
  "CN": "admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Shanghai",
      "L": "Shanghai",
      "O": "system:masters",
      "OU": "Kubernetes"
    }
  ]
}
EOF
cfssl gencert -ca=kube-ca.pem -ca-key=kube-ca-key.pem -config=ca-config.json \
kube-admin-csr.json | cfssljson -bare kube-admin

cat >kube-controller-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Shanghai",
      "L": "Shanghai",
      "O": "system",
      "OU": "Kubernetes"
    }
  ]
}
EOF
cfssl gencert -ca=kube-ca.pem -ca-key=kube-ca-key.pem -config=ca-config.json \
kube-controller-csr.json | cfssljson -bare kube-controller

cat >kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Shanghai",
      "L": "Shanghai",
      "O": "system",
      "OU": "Kubernetes"
    }
  ]
}
EOF
cfssl gencert -ca=kube-ca.pem -ca-key=kube-ca-key.pem -config=ca-config.json \
kube-scheduler-csr.json | cfssljson -bare kube-scheduler

cat >kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Shanghai",
      "L": "Shanghai",
      "O": "system",
      "OU": "Kubernetes"
    }
  ]
}
EOF
cfssl gencert -ca=kube-ca.pem -ca-key=kube-ca-key.pem -config=ca-config.json \
kube-proxy-csr.json | cfssljson -bare kube-proxy

cat >kubelet-csr.json <<EOF
{
  "CN": "system:kubelet",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Shanghai",
      "L": "Shanghai",
      "O": "system:node",
      "OU": "Kubernetes"
    }
  ]
}
EOF
cfssl gencert -ca=kube-ca.pem -ca-key=kube-ca-key.pem -config=ca-config.json \
kubelet-csr.json | cfssljson -bare kubelet

# Generate apiserver https certs
echo '{"CN":"kube-api","hosts":[""],"key":{"algo":"rsa","size":2048}}' |\
cfssl gencert -ca=kube-ca.pem -ca-key=kube-ca-key.pem -config=ca-config.json \
-hostname="${MASTER_IPS},127.0.0.1,localhost,kube-api,${KUBERNETES_SERVICE_IP}" - |\
cfssljson -bare kube-api

# Copy certs to kubernetes config directory(/etc/kubernetes on each master)
mkdir kubernetes
cp kube-ca.pem kubernetes
cp kubelet.pem kubernetes
cp kubelet-key.pem kubernetes
# masters only
cp etcd-cs-ca.pem kubernetes
cp etcd-client.pem kubernetes
cp etcd-client-key.pem kubernetes
cp kube-service-account.key kubernetes
cp kube-api.pem kubernetes
cp kube-api-key.pem kubernetes
cp kube-controller.pem kubernetes
cp kube-controller-key.pem kubernetes
cp kube-scheduler.pem kubernetes
cp kube-scheduler-key.pem kubernetes
cp kube-proxy.pem kubernetes
cp kube-proxy-key.pem kubernetes