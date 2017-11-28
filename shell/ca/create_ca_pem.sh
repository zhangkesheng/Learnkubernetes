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
cat >ca-csr.json <<EOF
{
"CN": "kubernetes",
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
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
