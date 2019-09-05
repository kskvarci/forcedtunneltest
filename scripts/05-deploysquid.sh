# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="DemoNet-Rg"
vnetName="HubVnet"
userName="your username here"
sshKey="your public ssh key here"

# Deploy an Ubuntu VM and install Squid Proxy
az vm create --name "Squid-Proxy" --resource-group $resourceGroupName --authentication-type "ssh" --admin-username $userName --boot-diagnostics-storage "" --location $location --nsg "" --image "Canonical:UbuntuServer:18.04-LTS:latest" --size "Standard_DS2" --ssh-key-value "$sshKey" --subnet "proxy-subnet" --vnet-name $vnetName --custom-data squid-cloud-init.yml