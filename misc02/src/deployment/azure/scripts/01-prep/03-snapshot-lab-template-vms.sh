#!/bin/bash

# Take a snapshot of the lab environment

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

az deployment sub create -l $REGION --template-file $DEPLOYMENTS_DIR/02-lab-template-snapshots/main.bicep --name $CHALLENGE_NAME-lab-template-snapshots