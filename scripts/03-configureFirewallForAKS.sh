# !/bin/bash

# Parameters
resourceGroupName="DemoNet-Rg"
scrCidr="10.1.0.0/24"

# Add firewall Rules for AKS comms
# https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic

# App Rules (Required)
# az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-API1 --protocols Https=443 Tcp=22 Tcp=9000 --resource-group $resourceGroupName --target-fqdns *.hcp.eastus2.azmk8s.io --source-addresses $scrCidr --priority 200 --action Allow
# az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-API2 --protocols Https=443 Tcp=22 Tcp=9000 --resource-group $resourceGroupName --target-fqdns *.tun.eastus2.azmk8s.io --source-addresses $scrCidr --priority 200 --action Allow
az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-API1 --protocols Https=443 --resource-group $resourceGroupName --target-fqdns *.hcp.eastus2.azmk8s.io --source-addresses $scrCidr --priority 200 --action Allow
az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-API2 --protocols Https=443 --resource-group $resourceGroupName --target-fqdns *.tun.eastus2.azmk8s.io --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-ACR --protocols Https=443 --resource-group $resourceGroupName --target-fqdns aksrepos.azurecr.io --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-ImageBlob --protocols Https=443 --resource-group $resourceGroupName --target-fqdns *.blob.core.windows.net --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-MCR --protocols Https=443 --resource-group $resourceGroupName --target-fqdns mcr.microsoft.com --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-MCRStorage --protocols Https=443 --resource-group $resourceGroupName --target-fqdns *.cdn.mscr.io --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-KubeGetPut --protocols Https=443 --resource-group $resourceGroupName --target-fqdns management.azure.com --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-ReqCol" --firewall-name TestNetFirewall --name Allow-AAD --protocols Https=443 --resource-group $resourceGroupName --target-fqdns login.microsoftonline.com --source-addresses $scrCidr

# App Rules (Optional)
az network firewall application-rule create --collection-name "AKS-OptCol" --firewall-name TestNetFirewall --name Allow-NodeUpdates --protocols Http=80 --resource-group $resourceGroupName --target-fqdns security.ubuntu.com azure.archive.ubuntu.com changelogs.ubuntu.com --source-addresses $scrCidr --priority 201 --action Allow
az network firewall application-rule create --collection-name "AKS-OptCol" --firewall-name TestNetFirewall --name Allow-MSAPT --protocols Https=443 --resource-group $resourceGroupName --target-fqdns packages.microsoft.com --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-OptCol" --firewall-name TestNetFirewall --name Allow-MonitorMetricsVS --protocols Https=443 --resource-group $resourceGroupName --target-fqdns dc.services.visualstudio.com --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-OptCol" --firewall-name TestNetFirewall --name Allow-MonitorMetricsInsights --protocols Https=443 --resource-group $resourceGroupName --target-fqdns *.opinsights.azure.com --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-OptCol" --firewall-name TestNetFirewall --name Allow-MonitorMetricsMonitoring --protocols Https=443 --resource-group $resourceGroupName --target-fqdns *.monitoring.azure.com --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-OptCol" --firewall-name TestNetFirewall --name Allow-AzurePol --protocols Https=443 --resource-group $resourceGroupName --target-fqdns gov-prod-policy-data.trafficmanager.net --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-OptCol" --firewall-name TestNetFirewall --name Allow-GPUAPT --protocols Https=443 --resource-group $resourceGroupName --target-fqdns apt.dockerproject.org --source-addresses $scrCidr
az network firewall application-rule create --collection-name "AKS-OptCol" --firewall-name TestNetFirewall --name Allow-GPUNVid --protocols Https=443 --resource-group $resourceGroupName --target-fqdns nvidia.github.io --source-addresses $scrCidr

# Network Rules
az network firewall network-rule create --collection-name "AKS-NetCol" --destination-addresses 91.189.89.198 91.189.89.199 91.189.94.4 91.189.91.157 --destination-ports 123 --firewall-name TestNetFirewall --name Allow-UbuntuNTP --protocols UDP --resource-group $resourceGroupName --priority 202 --source-addresses $scrCidr --action Allow
az network firewall network-rule create --collection-name "AKS-NetCol" --destination-addresses "*" --destination-ports 22 9000 --firewall-name TestNetFirewall --name Allow-MasterConn --protocols TCP --resource-group $resourceGroupName --source-addresses $scrCidr