#!/bin/bash
cat >etcd-csr.json <<EOF
{
  "CN": "kube-proxy",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "system:masters",
      "OU": "System"
    }
  ]
}
EOF
cfssl gencert -ca=kube-ca.pem -ca-key=kube-ca-key.pem -config=ca-config.json etcd.json | cfssljson -bare etcd
