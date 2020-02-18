# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="HubSpoke-Rg"

hubVnetName="HubVnet"

az extension add -n azure-firewall
# Deploy Azure Firewall
az network firewall create --name "SharedFirewall" --resource-group $resourceGroupName --location $location
# Create PiP
az network public-ip create --name "SharedFirewall-pip" --resource-group $resourceGroupName --location $location --allocation-method static --sku standard
# Create IP Config
az network firewall ip-config create --firewall-name "SharedFirewall" --name "FW-config" --public-ip-address "SharedFirewall-pip" --resource-group $resourceGroupName --vnet-name $hubVnetName
# Update the Firewall Config
az network firewall update --name "SharedFirewall" --resource-group $resourceGroupName

# Grab the private IP
fwprivaddr="$(az network firewall ip-config list -g $resourceGroupName -f SharedFirewall --query "[?name=='FW-config'].privateIpAddress" --output tsv)"

# TODO - add step to remove other DR
# Add a new default route to the FW
az network route-table route create --resource-group $resourceGroupName --name DG-Route --route-table-name "workload-udr" --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $fwprivaddr
