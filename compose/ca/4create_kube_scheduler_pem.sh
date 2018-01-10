#!/bin/bash
cat >kube-scheduler-csr.json <<EOF
{
  "CN": "kube-scheduler",
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
cfssl gencert -ca=kube-ca.pem -ca-key=kube-ca-key.pem -config=ca-config.json kube-scheduler-csr.json | cfssljson -bare kube-scheduler
