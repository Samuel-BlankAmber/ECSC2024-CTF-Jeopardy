#!/bin/sh

python3 db.py
gunicorn app:app -w 4 &

sh /docker-entrypoint.sh nginx -g 'daemon off;'