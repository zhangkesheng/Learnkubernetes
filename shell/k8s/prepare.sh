#!/bin/bash
clusters=$1
echo $clusters
# 设置防火墙
clusterHosts=$(echo $clusters|tr "," "\n")
for addr in $clusterHosts
do
    echo "ufw allow [$addr]";
	ufw allow from $addr;
done
## kubernetes目录
if [ ! -d "/etc/kubernetes" ]; then
	mkdir -p "/etc/kubernetes";
fi
# 如果工作目录不存在, 创建工作目录
if [ ! -d $dir ]; then
	mkdir -p $dir;
fi

#docker
## docker 版本
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')
apt-mark hold docker-ce
## docker代理
if [ ! -d "/etc/systemd/system/docker.service.d" ]; then
	mkdir -p /etc/systemd/system/docker.service.d
fi
cat > /etc/systemd/system/docker.service.d/http-proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=http://192.168.32.10:6780"
Environment="HTTPS_PROXY=http://192.168.32.10:6780"
Environment="NO_PROXY=.aliyun.com,.aliyuncs.com,.daocloud.io,.cn,localhost"
EOF
