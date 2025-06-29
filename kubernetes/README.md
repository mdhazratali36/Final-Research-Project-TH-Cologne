# Kubernetes Cluster Setup

## Overview
This directory contains scripts and configuration files for setting up a Kubernetes cluster using `kubeadm`. The cluster consists of at least one master node and one worker node.

## Contents
- `setup_k8sCluster.sh`: A shell script to automate the setup of a Kubernetes cluster.

## Setup and Usage

### Prerequisites
- Ensure you have root access to the machines intended to be master and worker nodes.
- The script must be executed on the master node.

### Steps

1. **Execute the Script:**
   - Make the script executable and run it:
     ```bash
     nano setup_k8sCluster.sh
     sudo chmod +x setup_k8sCluster.sh
     sudo ./setup_k8sCluster.sh
     ```
     Enter the name of the network interface:ens3
     find out the name of the network interface:Go to ubuntu machine>ip addr

2. **Network Configuration:**
   - During the script execution, you will be prompted to enter the network interface name. Use the output of `ip addr` to determine the correct interface.

3. **Join Worker Nodes:**
   - The script will provide a `kubeadm join` command. Execute this command on each worker node to join them to the cluster.

## Notes
- The script is designed for Ubuntu-based systems.
- Modify the script as needed for different network configurations or additional nodes.

