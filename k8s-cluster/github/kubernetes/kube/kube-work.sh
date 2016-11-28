#!/bin/bash
KUBE_ROOT=$(dirname "${BASH_SOURCE}")/

DEFAULT_KUBECONFIG="${HOME}/.kube/config"

source ~/kube/util.sh

export MASTER_IP=$1
if [ "$MASTER_IP" == "" ]; then
  echo  "please add MASTER_IP first param"
  exit
fi
if [ "$host" == "" ]; then
  host=$( ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1 )
  echo  "current node is $host"
fi

source ~/kube/config-default.sh

if [ -z "$CNI_PLUGIN_CONF" ] || [ -z "$CNI_PLUGIN_EXES" ]; then
  # Prep for Flannel use: copy the flannel binaries and scripts, set reconf flag
  NEED_RECONFIG_DOCKER=true
  CNI_PLUGIN_CONF=''

else
  # Prep for CNI use: copy the CNI config and binaries, adjust upstart config, set reconf flag
  NEED_RECONFIG_DOCKER=false
fi


function create-kubelet-opts() {
  if [ -n "$7" ] ; then
      cni_opts=" --network-plugin=cni --network-plugin-dir=/etc/cni/net.d"
  else
      cni_opts=""
  fi
  cat <<EOF > ~/kube/default/kubelet
KUBELET_OPTS="\
 --hostname-override=${1} \
 --api-servers=http://${2}:8080 \
 --logtostderr=true \
 --cluster-dns=${3} \
 --pod-infra-container-image=docker.io/kubernetes/pause:latest \
 --cluster-domain=${4} \
 --config=${5} \
 --allow-privileged=${6}
 $cni_opts"
EOF
}

# Create ~/kube/default/kube-proxy with proper contents.
# $1: The hostname or IP address by which the node is identified.
# $2: The one hostname or IP address at which the API server is reached (insecurely).
function create-kube-proxy-opts() {
  cat <<EOF > ~/kube/default/kube-proxy
KUBE_PROXY_OPTS="\
 --hostname-override=${1} \
 --master=http://${2}:8080 \
 --logtostderr=true \
 ${3}"
EOF

}

# Create ~/kube/default/flanneld with proper contents.
# $1: The one hostname or IP address at which the etcd leader listens.
# $2: The IP address or network interface for the local Flannel daemon to use
function create-flanneld-opts() {
  cat <<EOF > ~/kube/default/flanneld
FLANNEL_OPTS="--etcd-endpoints=http://${1}:4001 \
 --ip-masq \
 --iface=${2}"
EOF
}
function proxy-starts() {
  cp ~/kube/default/* /etc/default/
  cp ~/kube/init_conf/* /etc/init/
  cp ~/kube/init_scripts/* /etc/init.d/
  mkdir -p /opt/bin/
  cp ~/kube/minion/* /opt/bin
#restart Docker#config docker config
echo 'NEED_RECONFIG_DOCKER is' ${NEED_RECONFIG_DOCKER}
if ${NEED_RECONFIG_DOCKER}; then
  echo ${DOCKER_OPTS} is \"${DOCKER_OPTS}\"
   KUBE_CONFIG_FILE=\"${KUBE_CONFIG_FILE}\"
   DOCKER_OPTS=\"${DOCKER_OPTS}\"
   ~/kube/reconfDocker.sh i;
fi

  service flanneld start
  service kubelet  start
  service kube-proxy start


}

function create-proxy-config() {
  #statements
echo "ALLOW_PRIVILEGED is ${ALLOW_PRIVILEGED} "
 create-kubelet-opts \
    ${host} \
    ${MASTER_IP} \
    ${DNS_SERVER_IP} \
    ${DNS_DOMAIN} \
    '${KUBELET_CONFIG}' \
    ${ALLOW_PRIVILEGED} \
    ${CNI_PLUGIN_CONF}
  create-kube-proxy-opts \
    ${host} \
    ${MASTER_IP} \
    ${KUBE_PROXY_EXTRA_OPTS}
  create-flanneld-opts ${MASTER_IP} ${host}

}
#first config proxy
 create-proxy-config


# start proxy kubelet
 proxy-starts
