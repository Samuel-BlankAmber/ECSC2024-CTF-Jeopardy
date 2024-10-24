import random
import string

teams_id_map={}
with open("./teams_ids.txt") as f:
    lines = f.readlines()
    for line in lines:
        if line.strip()!="":
            name, id=line.split(",")
            id=int(id)
            teams_id_map[id]=name

# for whitepage
tokens = {"db069213e7462a925571f755c94f3a3a": 0, "0aa4c3c1c6bf03b0c9bf9a2a7b3a1431": 1, "d6a4cd22cbe0ed9d73f2a7f30bda65bc": 2, "fc1bff13eead1059dda3b3e48200e085": 3, "91bf0e6eb30c23520ff180545735bf39": 4, "920c7fdc243edd8ba417c72fff2fbc1f": 5, "8f61eb30af25ab091ae1051ce60bff23": 6, "ea8fb7e222c12adb5e449cdda766db39": 7, "572bd88281334a6d0a04ab5ff14900d9": 8, "3c5201f6096e4de6169a9044ca23ab76": 9, "2dac4e56764f0440ae0ab50ea7421579": 10, "fcd954d73183b8b73dec5d2e0afaf573": 11, "2a1822e6a91f9d0f5ee9773715fb9671": 12, "edb5a59fa2f85dcde3531823f733a1cc": 13, "1e98a1a5c4f68522101848a05fa206f6": 14, "60a9cdbc4ee34b50e1f56f0942ed13f3": 15, "5ad768d610271b48769525db3e638970": 16, "e6c4f009f7806059628da6c49a8f9358": 17, "c5508552612bac2c521b0ebe11205368": 18, "79b1f858820e4bf617f472793b8d5c74": 19, "4a80e0740b1011863183f8acc2a08533": 20, "8933f9a5b0bde40673fafe5e728cddce": 21, "1d725ebbf1bb9bddce67e91ea7893e11": 22, "653a243527e455f3a9903f907979ab1d": 23, "e2f86c258392f9bab71bca33e04368e9": 24, "da12cc3c71ac12f697476a36027be759": 25, "3f80de00a75d87c565bd83fdd9703389": 26, "cc52fd2bcc7580cbecdd066eb1c89d15": 27, "1ece88dbec751013c948fadd675facf5": 28, "2744cd7c41a02de54b6bbe2834de1fe0": 29, "949c7567ef5ee1e51597a857093e9118": 30, "3e96d1d65ac280e30ddddd242e832a70": 31, "d675260006a4acfe0386ee469418827d": 32, "5f432e066a6483f544213ed05a4ce67e": 33, "726437348e4d9b0fb3d0f3a58cd60138": 34, "8fb16fc761d3d097f1b6a425245aad4d": 35, "55a9fdc616d92c88d03af01ec3a7c0c6": 36, "5b9687879028f594fa573b0c8f21d8a1": 37}
inverted_tokens = {v: k for k, v in tokens.items()}


PSTN_IP="10.250.254.3"

passwords={}
phone_passwords={}

for x in teams_id_map.keys():
    passwords[x]=''.join(random.choices(string.ascii_uppercase + string.digits, k=16))
    phone_passwords[x]=''.join(random.choices(string.ascii_uppercase + string.digits, k=16))

pstn_config=f"""; Default UDP transport
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060
external_media_address = {PSTN_IP}
external_signaling_address = {PSTN_IP}

"""

for x in teams_id_map.keys():
    fullteamid=str(x).rjust(2,'0')
    pstn_config+=f"""; team {fullteamid} ({teams_id_map[x]})

[team{fullteamid}]
type=endpoint
context=default
disallow=all
allow=g722
auth=team{fullteamid}_auth
aors=team{fullteamid}
direct_media=no
rtp_symmetric = yes
force_rport = yes
rewrite_contact = yes

[team{fullteamid}]
type = aor
max_contacts = 1

[team{fullteamid}_auth]
type = auth
auth_type = userpass
username = 00{fullteamid}
password = {passwords[x]}
realm = asterisk

[team01]
type = identity
match = {PSTN_IP} ; sometimes you might need to use the actual IP Address
endpoint = team{fullteamid}

"""

with open("./asterisk_pstn/config/pjsip.conf", "w") as f:
    f.write(pstn_config)

import shutil
import os

if(os.path.isdir("./teams_asterisks")):
    shutil.rmtree('./teams_asterisks')

os.makedirs("./teams_asterisks")

for x in teams_id_map.keys():
    fullteamid=str(x).rjust(2,'0')
    #shutil.copytree("./asterisk_team_template", f"./teams_asterisks/{x}/")
    os.mkdir(f"./teams_asterisks/{x}/")
    config=f"""; Default UDP transport
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060
external_media_address = 10.151.0.3
external_signaling_address = 10.151.0.3

; Local team phone configuration

[localphone]
type=endpoint
context=default
disallow=all
allow=g722
allow=ulaw
allow=alaw
auth=authlocalphone
aors=localphone
direct_media=no
rtp_symmetric = yes
force_rport = yes
rewrite_contact = yes
mailboxes=localphone@default

[authlocalphone]
type=auth
auth_type=userpass
password={phone_passwords[x]}
username=00{fullteamid}

[localphone]
type=aor
max_contacts=1

; PSTN configuration

[pstn]
type = registration
endpoint = pstn
transport = transport-udp
outbound_auth = pstn_auth
server_uri = sip:{PSTN_IP}
client_uri = sip:team{fullteamid}@{PSTN_IP}
contact_user = pstn
expiration = 60
line = yes

[pstn]
type = aor
;max_contacts = 1
contact = sip:{PSTN_IP}
qualify_frequency = 25

[pstn_auth]
type = auth
auth_type = userpass
username = 00{fullteamid}
password = {passwords[x]}
realm = asterisk

[pstn]
type = endpoint
aors = pstn
disallow=all
allow=g722
context = pstn
outbound_auth = pstn_auth
direct_media = no
from_user = team{fullteamid}
from_domain = {PSTN_IP}
100rel = yes
"""
    with open(f"./teams_asterisks/{x}/pjsip.conf", "w") as f:
        f.write(config)
    with open(f"./teams_asterisks/{x}/.env", "w") as f:
        f.write(f"URL=http://{PSTN_IP}/update/{inverted_tokens[x]}")

gameinfo={}


for x in teams_id_map.keys():
    gameinfo[x]={}
    gameinfo[x]["name"]=teams_id_map[x]
    gameinfo[x]["number"]=f"00{str(x).rjust(2, '0')}"
    gameinfo[x]["phone_username"]=f"00{str(x).rjust(2, '0')}"
    gameinfo[x]["phone_password"]=phone_passwords[x]
    gameinfo[x]["PSTN_password"]=passwords[x]
    print(f"Info for team {teams_id_map[x]} with ID {x}:")
    print(f"  - Phone number: 00{str(x).rjust(2, '0')}")
    print(f"  - Phone username: 0000")
    print(f"  - Phone password: {phone_passwords[x]}")
    print(f"  - PSTN password: {passwords[x]}")

import json

with open("./gameinfo.json", "w") as f:
    json.dump(gameinfo, f)
