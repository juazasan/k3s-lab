#!/bin/bash

# Install k3d
GITHUB_URL=https://github.com/rancher/k3s/releases
VERSION_K3S=`curl -w "%{url_effective}" -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||'`
curl -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | sudo bash

# Start the cluster
k3d create --image "docker.io/rancher/k3s:$VERSION_K3S" --publish 8080:80 --workers 3 --wait 0

# Install kubectl
read -r -p "Install kubectl? [Y/n]" response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    mkdir $HOME/tmp 
    curl -s -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o $HOME/tmp/kubectl
    sudo chmod +x $HOME/tmp/kubectl
    sudo mv --force $HOME/tmp/kubectl /usr/local/bin
    rm -rf $HOME/tmp/kubectl 
fi

# Connect to k3s-default cluster
export KUBECONFIG=$(k3d get-kubeconfig)
kubetctl get nodes