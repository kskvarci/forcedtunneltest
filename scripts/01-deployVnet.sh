# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="DemoNet-Rg"
spokeVnetName="SpokeVnet"
hubVnetName="HubVnet"
sourceIP="xxx.xxx.xxx.xxx/32"

# Create a resource group
az group create --location $location --name $resourceGroupName

#_______________________________________________________________________________
# Create a Hub VNet
az network vnet create --resource-group $resourceGroupName --name $hubVnetName --address-prefixes "10.0.0.0/16"

# Create a subnet for our Firewall
az network vnet subnet create --resource-group $resourceGroupName --name "AzureFirewallSubnet" --vnet-name $hubVnetName --address-prefixes "10.0.0.0/24"

# Create a subnet for our proxy server
az network vnet subnet create --resource-group $resourceGroupName --name "proxy-subnet" --vnet-name $hubVnetName --address-prefixes "10.0.1.0/24"

# Create a subnet for a jumpbox
az network vnet subnet create --resource-group $resourceGroupName --name "jumpbox-subnet" --vnet-name $hubVnetName --address-prefixes "10.0.2.0/24"

#________________________________________________________________________________
# Create a Spoke VNet
az network vnet create --resource-group $resourceGroupName --name $spokeVnetName --address-prefixes "10.1.0.0/16"

# Create a subnet for our test workloads
az network vnet subnet create --resource-group $resourceGroupName --name "workload-subnet" --vnet-name $spokeVnetName --address-prefixes "10.1.0.0/24"

#_________________________________________________________________________________
# Create NSGs for each subnet
az network nsg create --resource-group $resourceGroupName --name "proxy-nsg"
az network nsg create --resource-group $resourceGroupName --name "jumpbox-nsg"
az network nsg create --resource-group $resourceGroupName --name "workload-nsg"

# Configure a rule on the workload NSG to block outbound internet access
az network nsg rule create --resource-group $resourceGroupName --name "dropinternet-outbound" --priority 100 --direction "Outbound" --protocol "*" --source-address-prefixes "*" --source-port-ranges "*" --destination-address-prefixes "Internet" --destination-port-ranges "*" --access "Deny" --nsg-name "workload-nsg"

# Configure a rule on the jumpbox NSG to allow inbound SSH.
az network nsg rule create --resource-group $resourceGroupName --name "ssh-inbound" --priority 100 --direction "Inbound" --protocol "*" --source-address-prefixes $sourceIP --source-port-ranges "*" --destination-address-prefixes "VirtualNetwork" --destination-port-ranges "22" --access "Allow" --nsg-name "jumpbox-nsg"

# assign the NSGs to the appropriate subnets
az network vnet subnet update --resource-group $resourceGroupName --name "workload-subnet" --vnet-name $spokeVnetName --network-security-group "workload-nsg"
az network vnet subnet update --resource-group $resourceGroupName --name "proxy-subnet" --vnet-name $hubVnetName --network-security-group "proxy-nsg"
az network vnet subnet update --resource-group $resourceGroupName --name "jumpbox-subnet" --vnet-name $hubVnetName --network-security-group "jumpbox-nsg"

# Create a user-defined route to drop internet detined traffic
az network route-table create --resource-group $resourceGroupName --name "workload-udr"
az network route-table route create --resource-group $resourceGroupName --name "dropinternet-route" --route-table-name "workload-udr" --address-prefix "0.0.0.0/0" --next-hop-type "None"

# Assign the internet blocking UDR to the workload subnet
az network vnet subnet update --resource-group $resourceGroupName --name "workload-subnet" --vnet-name $spokeVnetName --route-table "workload-udr"

# Peer Hub and Spoke Networks
az network vnet peering create --resource-group $resourceGroupName --name hubtospoke --vnet-name $hubVnetName --remote-vnet $spokeVnetName --allow-vnet-access
az network vnet peering create --resource-group $resourceGroupName --name spoketohub --vnet-name $spokeVnetName --remote-vnet $hubVnetName --allow-vnet-access