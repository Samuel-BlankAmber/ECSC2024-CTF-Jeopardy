import os
import sys

phones_save_path="./openvpn_data/phones_configs"

if(os.path.exists(phones_save_path)):
    print(f"{phones_save_path} path alredy exists, not overwriting")
    exit(-1)

N_TEAMS=os.getenv('N_TEAMS')

if(N_TEAMS==None):
    if(len(sys.argv)!=2 or (int(sys.argv[1])<=0)):
        print("Usage: ./gen_server_config.py <number of teams> or set N_TEAMS env variable")
        exit(-1)
    N_TEAMS=sys.argv[1]

N_TEAMS=int(N_TEAMS)

SERVER = "10.181.1."

CLIENT_DATA = """client
tls-client
remote-cert-tls server
topology subnet
cipher AES-128-CBC
remote {0} {1}
dev tun
route 10.150.0.0 255.255.0.0
route 10.151.0.0 255.255.0.0
route 10.250.0.0 255.255.0.0
route 10.251.0.0 255.255.0.0
keepalive 10 30
nobind
verb 3

tun-mtu 1500
fragment 1300
mssfix

<ca>
{2}
</ca>

<cert>
{3}
</cert>

<key>
{4}
</key>
"""


# gen client configs
os.chdir(os.path.dirname(os.path.realpath(__file__)))
os.mkdir(phones_save_path)

teams = [f"team{x}" for x in range(0,N_TEAMS+1)]

for i, team in enumerate(teams):
    ca = open(f"./openvpn_data/pkis/{team}-net/ca.crt").read().strip()
    cert = open(f"./openvpn_data/pkis/{team}-net/issued/{team}-phone.crt").read().strip()
    cert = cert[cert.index("-----BEGIN CERTIFICATE-----"):]
    key = open(f"./openvpn_data/pkis/{team}-net/private/{team}-phone.key").read().strip()
    data = CLIENT_DATA.format(SERVER+str(i), 1194, ca, cert, key)
    os.mkdir(phones_save_path+f"/{team}")
    open(f"{phones_save_path}/{team}/phone.conf", "w").write(data)
