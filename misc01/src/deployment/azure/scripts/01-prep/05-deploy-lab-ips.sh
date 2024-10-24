#!/bin/bash

# Create public IPs for the labs

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

az deployment sub create -l $REGION --template-file $DEPLOYMENTS_DIR/03-lab-ips/main.bicep --name $CHALLENGE_NAME-lab-ips