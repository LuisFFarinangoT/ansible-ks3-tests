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
  --set hubble.relay.enabled=true \
  --set hubble.ui.enabled=true
  --helm-set=operator.replicas=1


helm install cilium cilium/cilium --version 1.14.2 \
--namespace kube-system \
--set bgpControlPlane.enabled=true \
--set tunnel=disabled \
--set ipam.operator.clusterPoolIPv4PodCIDRList=10.42.0.0/16 \
--set kubeProxyReplacement=true \
--set k8sServiceHost=192.168.100.58git \
--set k8sServicePort=6443 \
--set routingMode=native \
--set autoDirectNodeRoutes=true \
--set ipv4NativeRoutingCIDR=10.42.0.0/16 \
--set loadBalancer.mode=dsr \
--set ipv4.enabled=true \
--set prometheus.enabled=true \
--set operator.prometheus.enabled=true \
--set hubble.enabled=true \
--set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}"
