#!/bin/bash
MASTER_IPS=$@
# Generate CA certs for etcd
cat >etcd-cs-ca-csr.json <<EOF
{
    "CN": "MYZD etcd CS CA",
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
cfssl gencert -initca etcd-cs-ca-csr.json | cfssljson -bare etcd-cs-ca

cat >etcd-peer-ca-csr.json <<EOF
{
    "CN": "MYZD etcd peer CA",
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
cfssl gencert -initca etcd-peer-ca-csr.json | cfssljson -bare etcd-peer-ca

# Generate peer certificate
echo '{"CN":"etcd-peer","hosts":[""],"key":{"algo":"rsa","size":2048}}' |\
cfssl gencert -ca=etcd-peer-ca.pem -ca-key=etcd-peer-ca-key.pem -config=ca-config.json \
-hostname="${MASTER_IPS},etcd-01,etcd-02,etcd-03" - |\
cfssljson -bare etcd-peer

# Generate server certificate
echo '{"CN":"etcd-server","hosts":[""],"key":{"algo":"rsa","size":2048}}' |\
cfssl gencert -ca=etcd-cs-ca.pem -ca-key=etcd-cs-ca-key.pem -config=ca-config.json \
-hostname="${MASTER_IPS},127.0.0.1,localhost,etcd-01,etcd-02,etcd-03" - |\
cfssljson -bare etcd-server

# Generate client certificates
echo '{"CN":"etcd-client","hosts":[""],"key":{"algo":"rsa","size":2048}}' |\
cfssl gencert -ca=etcd-cs-ca.pem -ca-key=etcd-cs-ca-key.pem -config=ca-config.json - |\
cfssljson -bare etcd-client

# Copy certs tp etcd config directory(/etc/etcd on each peer)
mkdir etcd
cp etcd-cs-ca.pem etcd
cp etcd-peer-ca.pem etcd
cp etcd-peer.pem etcd
cp etcd-peer-key.pem etcd
cp etcd-server.pem etcd
cp etcd-server-key.pem etcd
cp etcd-client.pem etcd
cp etcd-client-key.pem etcd
