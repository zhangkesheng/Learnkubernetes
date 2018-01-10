#!/bin/bash
command_exists() {
	command -v "$@" >/dev/null 2>&1
}
if command_exists cfssl; then
	echo "cfssl already exists"
else
	wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 &&
		chmod +x cfssl_linux-amd64 &&
		mv cfssl_linux-amd64 /usr/local/bin/cfssl
fi

if command_exists cfssljson; then
	echo "cfssljson already exists"
else
	wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 &&
		chmod +x cfssljson_linux-amd64 &&
		mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
fi

if command_exists cfssl-certinfo; then
	echo "cfssl-certinfo already exists"
else
	wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 &&
		chmod +x cfssl-certinfo_linux-amd64 &&
		mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo
fi
export PATH=/usr/local/bin:$PATH
