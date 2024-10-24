#!/bin/bash

# Delete all resource groups (labs) for the challenge

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

RGS=$(az group list --query "[?starts_with(name, '$RG_PREFIX')].name" -o tsv)

CONFIRM="n"
echo "Are you sure you want to delete all resources in the following resource groups?"
for RG in $RGS; do
    echo -e "\t$RG"
done
read -p "Type 'yes' to confirm: " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Exiting..."
    exit 1
fi

for RG in $RGS; do
    az group delete -f Microsoft.Compute/virtualMachines -y --no-wait -n $RG
done

echo "Resources are being deleted. You can monitor the progress in the Azure Portal."