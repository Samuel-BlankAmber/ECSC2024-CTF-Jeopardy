import json
import requests
from Yealink import Yealink
import random
import string
import sys
requests.packages.urllib3.disable_warnings() 

def team_server_from_id(id):
    return "10.151.0.3"

def get_csrf_token(s, path):
    r = s.get(f"{path}").text
    token = r.split("var g_strToken = \"")[1].split('";')[0]
    return token


def add_contact(s, base_url, name, number):
    token=get_csrf_token(s, f"{base_url}/servlet?m=mod_data&p=contactsbasic&q=load&group=0&page=1")
    contact_create_request=f'oldname=&name={requests.utils.quote(name)}&office={number}&mobile=&other=&ring=Auto&group=All%20Contacts&line=-1&photo=&autoDivert=&token={token}'
    s.post(f"{base_url}/servlet?m=mod_contact&p=updatecontact&q=add&Rajax=0.29862417907310523", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=contact_create_request)

with open("./gameinfo.json", "r") as f:
    gameinfo=json.load(f)


if(len(sys.argv)!=3):
    print("Usage python3 configure_phones.py <team id> <phone IP>")
    exit(-1)

team_phone_ip = sys.argv[1]
teamid = sys.argv[2]
team_phone_ip=f"10.170.{teamid}.{team_phone_ip}"

for teamid in [teamid]:
    print(f"Updating phone for team {gameinfo[teamid]['name']}")
    base_url = f"https://{team_phone_ip}"
    phone_admin_password="admin"
    if("phone_admin_password" in gameinfo[teamid]):
        phone_admin_password=gameinfo[teamid]["phone_admin_password"]
    s = requests.Session()
    s.verify=False
    index=s.get(f"{base_url}").text
    n=index.split("var g_rsa_n = ")[1].split(";")[0].replace('"',"")
    e=index.split("var g_rsa_e = ")[1].split(";")[0].replace('"',"")
    yealink_session=Yealink(s.cookies["JSESSIONID"])
    yealink_session.initEncrypt(int(n, 16), int(e, 16))
    login_query="username=" + "admin" + "&pwd=" + requests.utils.quote(yealink_session.encrypt(phone_admin_password.encode()))
    login_query += "&rsakey=" + requests.utils.quote(yealink_session.objencrypt["datakey"]) + "&rsaiv=" + requests.utils.quote(yealink_session.objencrypt["dataiv"])
    r=s.post(f"{base_url}/servlet?m=mod_listener&p=login&q=login&Rajax=0.8150042915186366", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=login_query)
    if("done" not in r.text):
        print("Auth failed")
        exit(-1)
    print("Logged in successfully")
    
    token=get_csrf_token(s,f"{base_url}/servlet?m=mod_data&p=settings-upgrade&q=load")

    s.post(f"{base_url}/servlet?m=mod_upgrade&q=beforeupgrade&Rajax=0.5762873475918397", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=f"token={token}")

    firmware=open(f"./firmware.rom", "rb").read()
    files={"UploadName":(f"firmware.conf", firmware)}
    path=f"/servlet?m=mod_upgrade&q=upgrade&native=true&maxlength={requests.utils.quote(yealink_session.ylform_rsa_encrypt(b'50MB'))}"
    r=s.post(f"{base_url}{path}", files=files)
    print(r.text)
    s.post(f"{base_url}/servlet?m=mod_upgrade&q=reboot&forcereboot=true&Rajax=0.9219027102327997", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=f"token={token}")