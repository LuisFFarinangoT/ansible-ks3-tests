#!/bin/bash
helm repo add cilium https://helm.cilium.io/
helm repo update
helm install cilium cilium/cilium
helm upgrade cilium cilium/cilium

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=arm64
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz



API_SERVER_IP=`hostname -I`
API_SERVER_PORT=6443
CLUSTER_ID=1
CLUSTER_NAME=`hostname`
POD_CIDR="10.42.0.0/16"
cilium install \
  --set cluster.id=${CLUSTER_ID} \
  --set cluster.name=${CLUSTER_NAME} \
  --set k8sServiceHost=${API_SERVER_IP} \
  --set k8sServicePort=${API_SERVER_PORT} \
  --set ipam.operator.clusterPoolIPv4PodCIDRList=$POD_CIDR \
  --set kubeProxyReplacement=true \
  --set bgpControlPlane.enabled=true \
  --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}" \
  --set hubble.relay.enabled=true \
  --set routingMode=native \
  --set autoDirectNodeRoutes=true \
  --set hubble.ui.enabled=true
  



API_SERVER_IP=`hostname -I`
API_SERVER_PORT=6443
CLUSTER_ID=1
CLUSTER_NAME=`hostname`
POD_CIDR="10.42.0.0/16"
cilium install \
  --set k8sServiceHost=${API_SERVER_IP} \
  --set k8sServicePort=${API_SERVER_PORT} \
  --set cluster.id=${CLUSTER_ID} \
  --set cluster.name=${CLUSTER_NAME} \
  --set ipam.operator.clusterPoolIPv4PodCIDRList=$POD_CIDR \
  --set bgpControlPlane.enabled=true \
  --set routingMode=native \
  --set autoDirectNodeRoutes=true \
  --set kubeProxyReplacement=true
