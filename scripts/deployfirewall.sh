# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="TestNet-Rg"
hubVnetName="HubVnet"

# Deploy Azure Firewall
az network firewall create --name "TestNetFirewall" --resource-group $resourceGroupName --location $location
# Create PiP
az network public-ip create --name "fw-pip" --resource-group $resourceGroupName --location $location --allocation-method static --sku standard
# Create IP Config
az network firewall ip-config create --firewall-name "TestNetFirewall" --name "FW-config" --public-ip-address "fw-pip" --resource-group $resourceGroupName --vnet-name $hubVnetName
# Update the Firewall Config
az network firewall update --name "TestNetFirewall" --resource-group $resourceGroupName