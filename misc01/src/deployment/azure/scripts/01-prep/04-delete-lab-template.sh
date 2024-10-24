#!/bin/bash

# Take a snapshot of the lab environment

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

az group delete -f Microsoft.Compute/virtualMachines -y -n rg-$CHALLENGE_NAME-lab-template