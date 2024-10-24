#!/bin/bash

# Deploy the lab template

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

az deployment sub create -l $REGION --template-file $DEPLOYMENTS_DIR/01-lab-template/main.bicep --query properties.outputs.labIp.value -o tsv --name $CHALLENGE_NAME-lab-template