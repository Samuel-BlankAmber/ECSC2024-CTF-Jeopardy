#!/bin/bash

# Restart the VMs in a team's lab. Use --force when the VMs are unresponsive.

# Example: ./restart-lab.sh 1
# Example: ./restart-lab.sh 1 --force

if [ -z "$1" ]; then
    echo "Team ID is required"
    exit 1
fi

TEAM_ID=$1

if [ $# -eq 2 ] && [ "$2" != "--force" ]; then
    echo "Invalid argument: $2"
    exit 1
fi

if [ -z "$2" ]; then
    FORCE=""
else
    FORCE="--force"
fi

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

RG_NAME="${RG_PREFIX}-${TEAM_ID}"

az vm list -g $RG_NAME --query "[].id" -o tsv
az vm restart --ids $(az vm list -g $RG_NAME --query "[].id" -o tsv) $FORCE
