# Kubernetes Manifests for Test Login App

## Overview
This directory contains the Kubernetes manifests and Helm chart for deploying the **Test Login App** to a Kubernetes cluster. The structure includes templates for defining Kubernetes resources and a `values.yaml` file for customizable configuration.



### Descriptions

- **`Chart.yaml`**: This file defines the metadata for the Helm chart, including the chart name, version, and description. It serves as the entry point for the Helm package manager to identify and deploy the chart.

- **`templates/`**: This directory contains the Kubernetes resource templates used by Helm to deploy the application.
  - **`argocd.yaml`**: A template for configuring the ArgoCD application, defining how ArgoCD will manage and sync this application in the Kubernetes cluster.
  - **`deployment.yaml`**: Defines the Kubernetes Deployment resource for the Test Login App, specifying how the application pods should be created and managed.
  - **`service.yaml`**: Defines the Kubernetes Service resource, which exposes the application pods to external traffic or other services within the cluster.

- **`values.yaml`**: This file contains the default configuration values for the Helm chart. It allows you to customize the deployment by overriding these values during the Helm install or upgrade process. The CI/CD pipeline automatically updates the image tag in this file based on the latest commit.

## Usage

### Deploying the Application

1. **Manual Deployment Using Helm**:
   - To deploy the Test Login App using Helm, run the following command from the root of your Helm chart (inside the `test-login-app` directory):
   - Install helm: https://helm.sh/docs/intro/install/
     ```bash
     curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
     chmod 700 get_helm.sh
     ./get_helm.sh
    
     ```
   - you can curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash if you want to live on the edge.

2. **Continuous Deployment with ArgoCD**:
   - The `argocd.yaml` template is used by ArgoCD to manage the deployment of this application. Ensure that the ArgoCD configuration is properly set up in your cluster to automatically sync with the GitLab repository.

### Customizing the Deployment
- Modify the `values.yaml` file to customize various aspects of the deployment, such as the Docker image, replica count, and other environment-specific settings.

- You can also modify the `deployment.yaml` and `service.yaml` templates if there are specific customizations needed for your Kubernetes resources.

## Notes
- Ensure that the `values.yaml` file is kept up-to-date with the correct image tags and configurations.
- Use ArgoCD's synchronization features to ensure your Kubernetes cluster is always in sync with the repository.
- The manifests in this folder, combined with Helm and ArgoCD, provide a flexible and powerful method to deploy and manage the Test    Login App in a Kubernetes environment. 
- Customize the `values.yaml` as needed to suit different environments or deployment strategies.
