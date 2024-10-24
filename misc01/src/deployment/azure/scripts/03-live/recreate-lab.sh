#!/bin/bash

# Recreate a team's lab

# Example: ./recreate-lab.sh 1

if [ -z "$1" ]; then
    echo "Team ID is required"
    exit 1
fi

TEAM_ID=$1

SCRIPT_DIR=$(dirname "$0")

$SCRIPT_DIR/delete.sh $TEAM_ID
$SCRIPT_DIR/create.sh $TEAM_ID