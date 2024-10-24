import os
import sys

save_path="./openvpn_data/server_configs"

if(os.path.exists(save_path)):
    print(f"{save_path} path alredy exists, not overwriting")
    exit(-1)

N_TEAMS=os.getenv('N_TEAMS')

if(N_TEAMS==None):
    if(len(sys.argv)!=2 or (int(sys.argv[1])<=0)):
        print("Usage: ./gen_server_config.py <number of teams> or set N_TEAMS env variable")
        exit(-1)
    N_TEAMS=sys.argv[1]

N_TEAMS=int(N_TEAMS)

SERVER_DATA = """server 10.151.3.1 255.255.255.0
mode server
tls-server
topology subnet
port 1194


push "route-gateway 10.151.3.1"

cipher AES-128-CBC
dev {0}
dev-type tun
dev {0}-net
keepalive 10 30
ping-timer-rem
persist-tun
persist-key

duplicate-cn
client-to-client
client-config-dir {0}-ccd
verb 3

txqueuelen 1000
tun-mtu 1500
fragment 1300
mssfix

<dh>
{1}
</dh>

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

os.mkdir(save_path)

teams = [f"team{x}" for x in range(0,N_TEAMS+1)]

for i, team in enumerate(teams):
    dh = open(f"./openvpn_data/pkis/{team}-net/dh.pem").read().strip()
    ca = open(f"./openvpn_data/pkis/{team}-net/ca.crt").read().strip()
    cert = open(f"./openvpn_data/pkis/{team}-net/issued/{team}-server.crt").read().strip()
    cert = cert[cert.index("-----BEGIN CERTIFICATE-----"):]
    key = open(f"./openvpn_data/pkis/{team}-net/private/{team}-server.key").read().strip()
    os.mkdir(f"{save_path}/{team}-ccd/")
    open(f"{save_path}/{team}-ccd/{team}-phone", "w").write(f"ifconfig-push 10.151.3.2 255.255.255.0")
    data = SERVER_DATA.format(team, dh, ca, cert, key)
    open(f"{save_path}/{team}.conf", "w").write(data)