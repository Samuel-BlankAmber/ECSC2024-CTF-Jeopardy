#!/bin/bash

SCRIPT_DIR=$(readlink -f $(dirname "$0"))
CONFIG_DIR=$SCRIPT_DIR/../config
ANSIBLE_DIR=$SCRIPT_DIR/../ansible
ANSIBLE_ROUTER_DIR=$ANSIBLE_DIR/router
AZURE_DIR=$SCRIPT_DIR/../azure
AZURE_SCRIPTS_DIR=$AZURE_DIR/scripts

echo "[*] Deploying Azure lab template..."

LAB_IP=$($AZURE_SCRIPTS_DIR/01-prep/01-deploy-lab-template.sh)

echo "[*] Lab IP: $LAB_IP"
echo "[+] Deploying Azure lab template...done"

echo "[*] Configuring router..."
cd $ANSIBLE_ROUTER_DIR
ansible-playbook -i inventory main.yml --extra-vars '{"lab_ip":"'$LAB_IP'"}'
echo "[+] Configuring router...done"

echo "[*] Deploying lab..."
ssh -o StrictHostKeyChecking=no -i $CONFIG_DIR/ssh_keys/lab -t -t -l deploy $LAB_IP './deploy.sh'
echo "[+] Deploying lab...done"

echo "[*] Shutting down VMs..."
$AZURE_SCRIPTS_DIR/01-prep/02-stop-lab-template-vms.sh
echo "[+] Shutting down VMs...done"

echo "[*] Taking snapshots..."
$AZURE_SCRIPTS_DIR/01-prep/03-snapshot-lab-template-vms.sh
echo "[+] Taking snapshots...done"
