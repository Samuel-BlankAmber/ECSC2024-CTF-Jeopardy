#!/bin/bash

# Delete a team's lab

# Example: ./delete-lab.sh 1

if [ -z "$1" ]; then
    echo "Team ID is required"
    exit 1
fi

TEAM_ID=$1

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

RG_NAME="${RG_PREFIX}-${TEAM_ID}"

CONFIRM="n"
echo "Are you sure you want to delete all resources in the following resource group?"
echo -e "\t$RG_NAME"
read -p "Type 'yes' to confirm: " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Exiting..."
    exit 1
fi

az group delete -f Microsoft.Compute/virtualMachines -y -n $RG_NAME

echo "Deleted resources in resource group $RG_NAME."