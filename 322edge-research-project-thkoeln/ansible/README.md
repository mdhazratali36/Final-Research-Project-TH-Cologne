## Ansible for Kubernetes Cluster Setup: K8s cluster deployment, adding worker nodes to cluster

https://docs.ansible.com/ansible/latest/installation_guide/index.html

### Overview
This directory contains Ansible playbooks and inventory files for setting up a Kubernetes cluster. The Ansible playbooks automate the process of installing and configuring Kubernetes on the specified nodes.

###  Contents
- `inventory.ini`: Inventory file listing the master and worker nodes with their respective IP addresses and SSH details.
- `playbook.yml`: Ansible playbook for setting up Kubernetes components (kubeadm, kubelet, kubectl) on all nodes.

1. **Install Ansible on Control Node**
   ```bash
   sudo apt update
   sudo apt install ansible -y
   ansible --version

2. **Prepare Inventory File (`inventory.ini`)**
    The `inventory.ini` file lists the hosts (nodes) that Ansible will manage. It includes:
   
   - **Master Node**: The control node where Ansible commands are executed.
   - **Worker Nodes**: The nodes that will be added to the Kubernetes cluster.
    
    Example structure:
    ```ini
    [master_node]
    <master_node_ip> ansible_ssh_user=<username>

    [worker_nodes]
    <worker_node_ip> ansible_ssh_user=<username>e.


3. **Create Ansible Playbooks**
    An Ansible playbook is a YAML file that defines a series of tasks to be executed on the managed nodes. It provides a way to     automate configuration, deployment, and orchestration.

   - Create a playbook to install Kubernetes components (kubeadm, kubelet, kubectl) on all nodes.
   - playbook.yml

   Example structure:
   ```bash
      name: Setup Kubernetes Worker Node
      hosts: worker_nodes
      become: yes
      tasks:----
           --------------
      

   Hosts: Specifies the group of hosts (from the inventory file) on which the tasks will run.
   Become: Indicates whether to run the tasks with elevated privileges (e.g., using sudo).
   Tasks: A list of actions to be performed on the hosts, such as installing software, configuring services, etc.
    


4. **Run Ansible Playbook:**
   - Execute the following command to run the playbook:
     ```bash
     ansible-playbook -i inventory.ini playbook.yml
     ```
   - This will install the necessary Kubernetes components on the specified nodes.
    
