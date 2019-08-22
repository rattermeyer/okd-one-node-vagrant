#!/bin/sh

yum -y update

yum install -y wget yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y  docker-ce docker-ce-cli containerd.io

mkdir /etc/docker /etc/containers

tee /etc/containers/registries.conf<<EOF
[registries.insecure]
registries = ['172.30.0.0/16']
EOF

tee /etc/docker/daemon.json<<EOF
{
   "insecure-registries": [
     "172.30.0.0/16"
   ]
}
EOF

systemctl daemon-reload
systemctl restart docker

systemctl enable docker

echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
sysctl -p


DOCKER_BRIDGE=`docker network inspect -f "{{range .IPAM.Config }}{{ .Subnet }}{{end}}" bridge`
firewall-cmd --permanent --new-zone dockerc
firewall-cmd --permanent --zone dockerc --add-source $DOCKER_BRIDGE
firewall-cmd --permanent --zone dockerc --add-port={80,443,8443}/tcp
firewall-cmd --permanent --zone dockerc --add-port={53,8053}/udp
firewall-cmd --reload

wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar xvf openshift-origin-client-tools*.tar.gz
cd openshift-origin-client*/
mv  oc kubectl  /usr/local/bin/

