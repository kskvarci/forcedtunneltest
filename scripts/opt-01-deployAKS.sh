# !/bin/bash

# Parameters
location="eastus2"
resourceGroupName="AKS-Workshop-Rg"

spokeVnetName="SpokeVnet"
hubVnetName="HubVnet"

PREFIX="kskaksclus"

# Create SP and Assign Permission to Virtual Network
az ad sp create-for-rbac -n "${PREFIX}sp" --skip-assignment
