#!/bin/bash
htpasswd -b -c /etc/nginx/.htpasswd user "$PASSWORD"
/docker-entrypoint.sh nginx -g "daemon off;"
