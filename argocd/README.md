## Setting Up ArgoCD for Continuous Deployment

## Overview
This directory contains the ArgoCD configuration files used to deploy and manage applications within the Kubernetes cluster. ArgoCD is responsible for continuous deployment, syncing the GitLab repository with the Kubernetes cluster.

## Contents
- `argocd.yaml`: Configuration file to define the ArgoCD application, specifying the source GitLab repository, target revision, and deployment path within the Kubernetes cluster.

1. **Install ArgoCD:**
   - Install ArgoCD in the Kubernetes cluster:
     ```bash
     kubectl create namespace argocd
     kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
     kubectl -n argocd get all
     kubectl -n argocd edit service argocd-server

     ```

2. **Access ArgoCD:**
   - Expose the ArgoCD server (type:NodePort):
     ```bash
     kubectl -n argocd get all
     kubectl get node -o wide
     ```
   - Retrieve the initial admin password and Login Using The CLI:
     ```bash
     argocd admin initial-password -n argocd
     or
     kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
     ```
   - Log in to the ArgoCD UI we need to install ArgoCD CLI.
   https://argo-cd.readthedocs.io/en/stable/cli_installation/
   ```bash
   curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/   argocd-linux-amd64
   sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
   rm argocd-linux-amd64

3. **Configure ArgoCD: Create argocd.yaml:**

   - The `argocd.yaml` file connects ArgoCD to the GitLab repository where the application's Helm charts or manifests are stored.
   - https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/
   - Automate setup argocd (argocd/ directory).
   - ArgoCD will automatically deploy the application defined in the `argocd.yaml` file.


## Notes
- The sync policy can be automated or manual, as specified in the `argocd.yaml`.
- Ensure ArgoCD is properly configured to connect to the GitLab repository.


