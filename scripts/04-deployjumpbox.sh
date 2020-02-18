# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="HubSpoke-Rg"

hubVnetName="HubVnet"

userName="your username here"
sshKey="your public ssh key here"

# Deploy a jumpbox VM
az vm create --name "Jumpbox" --resource-group $resourceGroupName --authentication-type "ssh" --admin-username $userName --boot-diagnostics-storage "" --location $location --nsg "" --image "Canonical:UbuntuServer:18.04-LTS:latest" --size "Standard_DS2" --ssh-key-value "$sshKey" --subnet "jumpbox-subnet" --vnet-name $hubVnetName