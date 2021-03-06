#!/bin/bash
if [ "$#" -eq 0 ]; then
  nodes=( )
else
  nodes=( "$@" )
fi

var=$(printf '\"%s\",' "${nodes[@]}")

cat >kubernetes-csr.json <<EOF
{
    "CN": "kubernetes",
    "hosts": [
        $var
        "127.0.0.1",
        "10.254.0.1",
        "kubernetes",
        "kubernetes.default",
        "kubernetes.default.svc",
        "kubernetes.default.svc.cluster",
        "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "BeiJing",
            "L": "BeiJing",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes
