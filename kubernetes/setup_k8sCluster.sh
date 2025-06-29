#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)

read -p "Enter the name of the network interface: " INTERFACE
read -p "Is this device gonna be the master? (yes/no): " MASTER

if [ "$MASTER" = "yes" ]; then
  read -p "Is the master gonna use a public ip (In most cases it is NOT public)? (yes/no): " PUBLIC_IP_ACCESS

fi


#!/bin/bash

COUNTDOWN=3

echo -n "Starting installation of Kubernetes in: "
while [ $COUNTDOWN -gt 0 ]; do
    echo -n "$COUNTDOWN, "
    sleep 1
    COUNTDOWN=$((COUNTDOWN - 1))
done
echo "now!"


# Kuernetes Variable Declaration
KUBERNETES_VERSION="1.29.0-1.1"

# disable swap
sudo swapoff -a

# keeps the swaf off during reboot
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
sudo apt-get update -y


# Install CRI-O Runtime

OS="xUbuntu_22.04"

VERSION="1.28"

# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

sudo apt-get update
sudo apt-get install cri-o cri-o-runc -y

sudo systemctl daemon-reload
sudo systemctl enable crio --now

echo "CRI runtime installed susccessfully"

# Install kubelet, kubectl and Kubeadm

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-1-28-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-1-28-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes-1.28.list

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-1-29-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-1-29-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes-1.29.list

sudo apt-get update -y
sudo apt-get install -y kubelet="$KUBERNETES_VERSION" kubectl="$KUBERNETES_VERSION" kubeadm="$KUBERNETES_VERSION"
sudo apt-get update -y
sudo apt-mark hold kubelet kubeadm kubectl

sudo apt-get install -y jq

local_ip="$(ip --json addr show $INTERFACE | jq -r '.[0].addr_info[] | select(.family == "inet") | .local')"
cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF

if [ "$MASTER" = "yes" ]; then
  COUNTDOWN=3
  echo -n "Starting installation of Master in: "
  while [ $COUNTDOWN -gt 0 ]; do
      echo -n "$COUNTDOWN, "
      sleep 1
      COUNTDOWN=$((COUNTDOWN - 1))
  done
  echo "now!"
  #!/bin/bash
  #
  # Setup for Control Plane (Master) servers

  set -euxo pipefail

  # If you need public access to API server using the servers Public IP adress, change PUBLIC_IP_ACCESS to true.

  NODENAME=$(hostname -s)
  POD_CIDR="192.168.0.0/16"

  # Pull required images

  sudo kubeadm config images pull

  # Initialize kubeadm based on PUBLIC_IP_ACCESS

  if [[ "$PUBLIC_IP_ACCESS" == "no" ]]; then

      MASTER_PRIVATE_IP=$(ip addr show $INTERFACE | awk '/inet / {print $2}' | cut -d/ -f1)
      sudo kubeadm init --apiserver-advertise-address="$MASTER_PRIVATE_IP" --apiserver-cert-extra-sans="$MASTER_PRIVATE_IP" --pod-network-cidr="$POD_CIDR" --ignore-preflight-errors Swap

  elif [[ "$PUBLIC_IP_ACCESS" == "yes" ]]; then

      MASTER_PUBLIC_IP=$(curl ifconfig.me && echo "")
      sudo kubeadm init --control-plane-endpoint="$MASTER_PUBLIC_IP" --apiserver-cert-extra-sans="$MASTER_PUBLIC_IP" --pod-network-cidr="$POD_CIDR" --ignore-preflight-errors Swap

  else
      echo "Error: MASTER_PUBLIC_IP has an invalid value: $PUBLIC_IP_ACCESS"
      exit 1
  fi

  # Configure kubeconfig

  mkdir -p "$HOME"/.kube
  sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
  sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

  # Install Claico Network Plugin Network

  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

  set +x #Disable Bash debugging :)

  echo "############################IMPORTANT#####################################"
  echo "IMPORTANT! Please check if the kubeconfig got created otherwise use:"
  echo "sudo mkdir -p $HOME/.kube"
  echo "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config"
  echo "sudo chown $(id -u):$(id -g) $HOME/.kube/config"
  echo "export KUBECONFIG=/etc/kubernetes/kubelet.conf"
  echo "##########################################################################"
  echo ""
  echo "Type: 'sudo kubeadm token create --print-join-command' to get the join command"
  echo ""
  echo "##########################################################################"
fi

