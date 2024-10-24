#!/usr/bin/env python3

import base64
import hmac
import json
import requests
import json
import os
from io import BytesIO
from impacket.smbconnection import SMBConnection

FLAG_DST = "/flag/flag.txt"
HOST = "10.151.2.101"
LOOKUP_KEY = "dcb"
FILE_SHARE_READ         = 0x00000001
FILE_SHARE_WRITE        = 0x00000002

with open("/home/deploy/config.json", "r") as f:
    config = json.load(f)

credentials = config["credentials"][LOOKUP_KEY]
username = credentials["username"]
password = credentials["password"]

# Load configuration
script_dir = os.path.dirname(os.path.realpath(__file__))
with open(os.path.join(script_dir, "config.json"), "rb") as config_file:
    config = json.load(config_file)
FLAG_KEY = config["flagKey"]
FLAG_TEMPLATE = config["flagTemplate"]

# Fetch team ID and generate team seed
response = requests.get(
    "http://169.254.169.254/metadata/instance/compute/userData?api-version=2021-01-01&format=text",
    headers={"Metadata": "true"},
)
custom_data = json.loads(base64.b64decode(response.text.encode()).decode())
team_id = custom_data["teamId"]
team_seed = hmac.new(FLAG_KEY.encode(), str(team_id).encode(), "sha256").hexdigest()[:8]
flag = FLAG_TEMPLATE.replace("}", f"_{team_seed}}}")
if team_id == 0:
    exit()

smbClient = SMBConnection(HOST, HOST, sess_port=445)
smbClient.login(username, password)

smbClient.connectTree("C$")

should_place_flag = False
try:
    fh = BytesIO()
    smbClient.getFile("C$", FLAG_DST, fh.write, FILE_SHARE_READ | FILE_SHARE_WRITE)
    output = fh.getvalue()
    remote_flag = output.decode()
    print(f"Remote flag: {remote_flag}")
    print(f"Generated flag: {flag}")
    if remote_flag != flag:
        should_place_flag = True
except Exception as e:
    print(f"Failed to read remote flag: {e}")
    should_place_flag = True

if should_place_flag:
    print("Placing flag")
    smbClient.putFile("C$", FLAG_DST, BytesIO(flag.encode()).read)
