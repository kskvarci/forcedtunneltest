# !/bin/bash

# Before running:
# az feature register --name AKSLockingDownEgressPreview --namespace Microsoft.ContainerService
# az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AKSLockingDownEgressPreview')].{Name:name,State:properties.state}"
# until registered
# az provider register --namespace Microsoft.ContainerService

# Parameters
location="eastus2"
resourceGroupName="AKS-Workshop-Rg"

spokeVnetName="SpokeVnet"
hubVnetName="HubVnet"

APPID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
PASSWORD="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Grab the VNet ID
VNETID=$(az network vnet show -g $resourceGroupName --name $spokeVnetName --query id -o tsv)

# Grant the SP access to the VNet
az role assignment create --assignee $APPID --scope $VNETID --role Contributor

# Create Log Analytics Workspace
az group deployment create -n "aks-la-workspace" -g $resourceGroupName --template-file azuredeploy-loganalytics.json --parameters workspaceName=aks-la-workspace location=eastus sku="Standalone"

# Grab the workspace ID
WORKSPACEIDURL=$(az group deployment list -g $resourceGroupName -o tsv --query '[].properties.outputResources[0].id')

# Make sure you're using a version that is valid for the current region
# az aks get-versions -l $location -o table

# Grab the AKS subnet ID
SUBNETID=$(az network vnet subnet show -g $resourceGroupName --vnet-name $spokeVnetName --name "workload-subnet" --query id -o tsv)

# Create AKS Cluster!
az aks create -g $resourceGroupName -n "aks-cluster" -k 1.14.6 -l $location --node-count 2 --generate-ssh-keys --enable-addons monitoring --workspace-resource-id $WORKSPACEIDURL --network-plugin azure --network-policy azure --service-cidr 10.41.0.0/16 --dns-service-ip 10.41.0.10 --docker-bridge-address 172.17.0.1/16 --vnet-subnet-id $SUBNETID --service-principal $APPID --client-secret $PASSWORD --no-wait