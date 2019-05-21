# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="TestNet-Rg"
vnetName="TestVnet"
userName="your username here"
sshKey="your public ssh key here"

# Deploy an Ubuntu VM and install Squid Proxy
az vm create --name "squid-proxy2" --resource-group $resourceGroupName --authentication-type "ssh" --admin-username $userName --boot-diagnostics-storage "" --location $location --nsg "" --image "Canonical:UbuntuServer:18.04-LTS:latest" --size "Standard_DS2" --ssh-key-value "$sshKey" --subnet "proxy-subnet" --vnet-name $vnetName --custom-data squid-cloud-init.yml