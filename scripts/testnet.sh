# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="TestNet-Rg"
vnetName="TestVnet"
sourceIP="xxx.xxx.xxx.xxx/32"

# Create a resource group
az group create --location $location --name $resourceGroupName

# Create a VNet
az network vnet create --resource-group $resourceGroupName --name $vnetName --address-prefixes "10.0.0.0/16"

# Create a subnet for our test workloads
az network vnet subnet create --resource-group $resourceGroupName --name "workload-subnet" --vnet-name $vnetName --address-prefixes "10.0.0.0/24"

# Create a subnet for our proxy server
az network vnet subnet create --resource-group $resourceGroupName --name "proxy-subnet" --vnet-name $vnetName --address-prefixes "10.0.1.0/24"

# Create a subnet for other infrastructure
az network vnet subnet create --resource-group $resourceGroupName --name "infra-subnet" --vnet-name $vnetName --address-prefixes "10.0.2.0/24"

# Create NSGs for each subnet
az network nsg create --resource-group $resourceGroupName --name "workload-nsg"
az network nsg create --resource-group $resourceGroupName --name "proxy-nsg"
az network nsg create --resource-group $resourceGroupName --name "infra-nsg"

# Configure a rule on the workload NSG to block outbound internet access
az network nsg rule create --resource-group $resourceGroupName --name "dropinternet-outbound" --priority 100 --direction "Outbound" --protocol "*" --source-address-prefixes "*" --source-port-ranges "*" --destination-address-prefixes "Internet" --destination-port-ranges "*" --access "Deny" --nsg-name "workload-nsg"

# Configure a rule on the proxy NSG to allow inbound SSH
z network nsg rule create --resource-group $resourceGroupName --name "ssh-inbound" --priority 100 --direction "Inbound" --protocol "*" --source-address-prefixes $sourceIP --source-port-ranges "*" --destination-address-prefixes "VirtualNetwork" --destination-port-ranges "22" --access "Allow" --nsg-name "proxy-nsg"

# assign the NSGs to the appropriate subnets
az network vnet subnet update --resource-group $resourceGroupName --name "workload-subnet" --vnet-name $vnetName --network-security-group "workload-nsg"
az network vnet subnet update --resource-group $resourceGroupName --name "proxy-subnet" --vnet-name $vnetName --network-security-group "proxy-nsg"
az network vnet subnet update --resource-group $resourceGroupName --name "infra-subnet" --vnet-name $vnetName --network-security-group "infra-nsg"

# Create a user-defined route to drop internet detined traffic
az network route-table create --resource-group $resourceGroupName --name "dropinternet-udr"
az network route-table route create --resource-group $resourceGroupName --name "dropinternet-route" --route-table-name "dropinternet-udr" --address-prefix "0.0.0.0/0" --next-hop-type "None"

# Assign the internet blocking UDR to the workload subnet
az network vnet subnet update --resource-group $resourceGroupName --name "workload-subnet" --vnet-name $vnetName --route-table "dropinternet-udr"