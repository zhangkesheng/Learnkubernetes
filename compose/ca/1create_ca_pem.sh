#!/bin/bash
cat >ca-config.json <<EOF
{
    "signing": {
        "default": {
            "expiry": "87600h"
        },
        "profiles": {
            "kubernetes": {
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ],
                "expiry": "87600h"
            }
        }
    }
}
EOF
cat >kube-ca.json <<EOF
{
"CN": "kube-ca",
"key": {
    "algo": "rsa",
    "size": 2048
},
"names": [
    {
    "C": "CN",
    "ST": "BeiJing",
    "L": "BeiJing",
    "O": "kubernetes",
    "OU": "System"
    }
]
}
EOF
cfssl gencert -initca ca-csr.json -config=ca-config.json | cfssljson -bare kube-ca
