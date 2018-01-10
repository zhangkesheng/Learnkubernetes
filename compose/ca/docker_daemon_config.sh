#!/bin/bash
cat >/etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://1.mirror.aliyuncs.com"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m"
  },
  "bridge": "docker0",
  "iptables": false,
  "ip-masq": false
}
EOF