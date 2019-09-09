# !/bin/bash

# Install HELM before running the below.

# Set up a role for Tiller
kubectl apply -f helm-rbac.yaml

# init helm in the cluster
helm init --history-max 200 --service-account tiller --node-selectors "beta.kubernetes.io/os=linux"

# Create a namespace for your ingress resources
kubectl create namespace ingress-basic

# Use Helm to deploy an internal NGINX ingress controller
helm install stable/nginx-ingress --namespace ingress-basic -f internal-ingress.yaml --set controller.replicaCount=2 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

