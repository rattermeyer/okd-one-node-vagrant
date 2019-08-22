yum install -y git vim
export DOMAIN=192.168.33.10.nip.io
export USERNAME=richard
export PASSWORD=changeit
curl https://raw.githubusercontent.com/gshipley/installcentos/master/install-openshift.sh | INTERACTIVE=false /bin/bash
oc login -u system:admin https://console.192.168.33.10.nip.io:8443
oc adm policy add-cluster-role-to-user cluster-admin ${USERNAME} --as=system:admin
