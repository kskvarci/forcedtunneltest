# !/bin/bash

# Install HELM before running the below.

# Install Hello World Apps to test Ingress
helm repo add azure-samples https://azure-samples.github.io/helm-charts/
helm install azure-samples/aks-helloworld --namespace ingress-basic
helm install azure-samples/aks-helloworld --namespace ingress-basic --set title="AKS Ingress Demo" --set serviceName="ingress-demo"

# Create ingress resource
kubectl apply -f hello-world-ingress.yaml