#!/bin/bash

# Stop the lab template VMs

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

az vm deallocate --ids $(az vm list --resource-group rg-$CHALLENGE_NAME-lab-template --query "[].id" -o tsv)
