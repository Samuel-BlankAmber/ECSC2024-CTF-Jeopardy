#!/bin/bash

# Create single lab for a team

# Example: ./create-lab.sh 1

if [ -z "$1" ]; then
    echo "Team ID is required"
    exit 1
fi

TEAM_ID=$1

SCRIPT_DIR=$(dirname "$0")
SCRIPTS_DIR=$SCRIPT_DIR/..
source $SCRIPTS_DIR/vars

az deployment sub create -l $REGION --template-file $DEPLOYMENTS_DIR/single-lab/main.bicep --parameters teamId=$TEAM_ID --name $CHALLENGE_NAME-single-lab-$TEAM_ID