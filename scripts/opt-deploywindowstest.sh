# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="DemoNet-Rg"
spokeVnetName="SpokeVnet"
hubVnetName="HubVnet"
userName="your username here"
password="your password here"

# Deploy a jump box with a public IP into the infra-subnet
az vm create --name "WindowsJump" --resource-group $resourceGroupName --authentication-type "Password" --admin-username $userName  --admin-password $password --boot-diagnostics-storage "" --location $location --nsg "" --image "MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest" --size "Standard_DS4" --subnet "jumpbox-subnet" --vnet-name $hubVnetName

# Deploy a server into the workload-subnet with no public IP
az vm create --name "WindowsTest" --resource-group $resourceGroupName --authentication-type "Password" --admin-username $userName  --admin-password $password --boot-diagnostics-storage "" --location $location --nsg "" --image "MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest" --size "Standard_DS4" --subnet "workload-subnet" --vnet-name $spokeVnetName --public-ip-address ""