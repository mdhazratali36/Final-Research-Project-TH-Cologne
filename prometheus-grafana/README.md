## Setting Up Monitoring with Prometheus and Grafana
https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack/

1. **Install Prometheus and Grafana:**
   - Use Helm to install Prometheus and Grafana:
     ```bash
     helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
     helm repo add grafana https://grafana.github.io/helm-charts
     helm repo update

     # Install Prometheus
     helm install [RELEASE_NAME] prometheus-community/kube-prometheus-stack
     helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

     ```

2. **Access Grafana:**
   - Retrieve the Grafana username and password:
     ```bash
     default-username: admin
     
     kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
     ```

3. **Configure Monitoring Dashboards:**
   - Set up dashboards in Grafana to visualize metrics from Prometheus.
