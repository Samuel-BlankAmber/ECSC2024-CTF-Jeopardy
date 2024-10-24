#!/bin/bash

# Create all labs

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

az deployment sub create -l $REGION --template-file $DEPLOYMENTS_DIR/04-team-labs/main.bicep --name $CHALLENGE_NAME-team-labs