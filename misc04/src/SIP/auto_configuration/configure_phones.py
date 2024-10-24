import json
import requests
from Yealink import Yealink
import random
import string
import sys
import time
from datetime import datetime
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
    if(team_phone_ip!=f"10.170.{teamid}.2"):
        print(f"Changing IP address of team {gameinfo[teamid]['name']}")
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

        token=get_csrf_token(s,f"{base_url}/servlet?m=mod_data&p=network&q=load")
        request_data=f"&NetworkWanType=2&NetworkWanStaticIp=10.170.{teamid}.2&NetworkWanStaticMask=255.255.255.0&NetworkWanStaticGateWay=10.170.{teamid}.1&NetworkWanStaticPriDns=1.1.1.1&NetworkWanStaticSecDns=1.0.0.1&token={token}"
        r = s.post(f"{base_url}/servlet?m=mod_data&p=network&q=write&Rajax=0.4758095344844149", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=request_data)

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

        token=get_csrf_token(s,f"{base_url}/servlet?m=mod_data&p=network&q=load")
        r = s.post(f"{base_url}/servlet?m=mod_data&q=applycacheconfig&Rajax=0.4967882940202939", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=f"token={token}")
        if('"ret":"ok"' not in r.text):
            print("IP config load failed")
            exit(-1)
        time.sleep(10)
        team_phone_ip=f"10.170.{teamid}.2"

    print(f"Configuring phone for team {gameinfo[teamid]['name']}")
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

    if(phone_admin_password=="admin"):

        print("Changing admin password")
        new_admin_password=''.join(random.choices(string.ascii_uppercase + string.digits, k=16))
        print("New password: ", new_admin_password)
        token=get_csrf_token(s,f"{base_url}/servlet?m=mod_data&p=security&q=load")
        chng_password_request=f"&editOldPassword={requests.utils.quote(yealink_session.encrypt(phone_admin_password.encode()))}&editNewPassword={requests.utils.quote(yealink_session.encrypt(new_admin_password.encode()))}&token={token}&mode=admin"
        chng_password_request += "&rsakey=" + requests.utils.quote(yealink_session.objencrypt["datakey"]) + "&rsaiv=" + requests.utils.quote(yealink_session.objencrypt["dataiv"])
        r=s.post(f"{base_url}/servlet?m=mod_password&p=security&q=change&Rajax=0.7767379551416815", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=chng_password_request)
        if("{'result' : '0'}" not in r.text):
            print("Change password fail")
            exit(-1)
        
        gameinfo[teamid]["phone_admin_password"] = new_admin_password
        phone_admin_password=new_admin_password
        print("Logging in with new password")
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


    token=get_csrf_token(s,f"{base_url}/servlet?m=mod_data&p=settings-datetime&q=load")
    now = datetime.now()
    time_query=f"LocalTimeDaylightSaving=0&ManualYear={now.year}&ManualMonth={now.month}&ManualDay={now.day}&ManualHour={now.hour}&ManualMinute={now.minute}&ManualSecond={now.second}&token={token}&CurrentTimeZoneTime=+2&CurrentTimeZoneZone=None"

    r = s.post(f"{base_url}/servlet?m=mod_data&p=settings-datetime&q=write&Rajax=0.25814819206286344", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=time_query)
    print("Time configuration changed")


    token=get_csrf_token(s,f"{base_url}/servlet?m=mod_data&p=account-register&q=load")
    SIP_server_config=f'&AccountLabel={gameinfo[teamid]["number"]}&AccountDisplayName={gameinfo[teamid]["number"]}&AccountRegisterName={gameinfo[teamid]["phone_username"]}&AccountUserName=localphone&AccountPassword={requests.utils.quote(yealink_session.encrypt(gameinfo[teamid]["phone_password"].encode()))}&server1={team_server_from_id(teamid)}&port1=5060&Expires1=60&RetryCounts1=5&token={token}&Transport1=0&AccountEnable=1'
    SIP_server_config += "&rsakey=" + requests.utils.quote(yealink_session.objencrypt["datakey"]) + "&rsaiv=" + requests.utils.quote(yealink_session.objencrypt["dataiv"])
    r = s.post(f"{base_url}/servlet?m=mod_data&p=account-register&q=write&acc=0&Rajax=0.8262535763362622", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=SIP_server_config)
    print("SIP configuration changed")

    print("Getting registered contacts")
    contacts=s.get(f"{base_url}/servlet?m=mod_data&p=contactsbasic&q=load").text.split("var g_contacts = g_json.ParseJSON(\"")[1].split("\");")[0].encode().decode('unicode_escape')
    contacts = json.loads(contacts)
    contacts = [contacts[x] for x in contacts if x not in ["con_total", "page_count"]]
    contact_names=[x["con_name"] for x in contacts]
    print(contacts)

    print("Adding contacts to directory")

    for otherteam in gameinfo.keys():
        if otherteam!=teamid:
            if gameinfo[otherteam]["name"] not in contact_names:
                print(f"Adding team {gameinfo[otherteam]['name']} at {gameinfo[otherteam]['number']}")
                add_contact(s, base_url, gameinfo[otherteam]['name'], gameinfo[otherteam]['number'])

    if("System configuration" not in contact_names):
        print(f"Adding System configuration at {gameinfo[otherteam]['number']}")
        add_contact(s, base_url, "System configuration", "0099")
    
    print("Now connecting phone to VPN, hold back!")
    

    vpnfile=open(f"./openvpn/openvpn_data/phones_configs/team{teamid}/phone.conf", "rb").read()
    files={"UploadName":(f"{teamid}.cnf", vpnfile)}
    path=f"/servlet?m=mod_res&p=upload&type=vpnfile&maxlength={requests.utils.quote(yealink_session.ylform_rsa_encrypt(b'2MB'))}"
    r=s.post(f"{base_url}{path}", files=files)
    if('"result":true}' not in r.text):
        print("VPN upload failed")
        exit(-1)
    
    token=get_csrf_token(s,f"{base_url}/servlet?m=mod_data&p=network-adv&q=load")
    s.post(f"{base_url}/servlet?m=mod_data&p=network-adv&q=write&Rajax=0.6021095543190391", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=f"token={token}&VpnSwitch=1")
    

    token=get_csrf_token(s,f"{base_url}/servlet?m=mod_data&p=network-adv&q=load")
    s.post(f"{base_url}/servlet?m=mod_data&q=applycacheconfig&Rajax=0.6837847256424276", headers={"Content-Type": "application/x-www-form-urlencoded"}, data=f"token={token}")
    if('"result":true' not in r.text):
            print("VPN load failed")
            print(r.text)
            exit(-1)


with open("./gameinfo.json", "w") as f:
    json.dump(gameinfo, f, indent=2)