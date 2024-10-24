#!/bin/bash

# Allow internet access
sudo iptables -P FORWARD ACCEPT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

/home/deploy/.local/bin/ansible-playbook -i lab/inventory lab/main.yml --extra-vars @config.json

# Block internet access
sudo iptables -P FORWARD DROP
sudo iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
