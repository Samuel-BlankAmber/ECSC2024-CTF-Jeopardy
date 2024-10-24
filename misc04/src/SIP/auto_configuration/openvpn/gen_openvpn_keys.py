import os
import sys
import subprocess

save_path="./openvpn_data/pkis"

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

teams = [f"team{x}" for x in range(0,N_TEAMS+1)]

for team in teams:
    print(subprocess.getoutput(f"./easyrsa/easyrsa --pki-dir='{save_path}/{team}-net' init-pki"))
    print(subprocess.getoutput(f"EASYRSA_REQ_CN='{team}-net' ./easyrsa/easyrsa --batch --pki-dir='{save_path}/{team}-net' build-ca nopass"))
    print(subprocess.getoutput(f"./easyrsa/easyrsa --batch --pki-dir='{save_path}/{team}-net' build-client-full '{team}-phone' nopass"))
    print(subprocess.getoutput(f"./easyrsa/easyrsa --batch --pki-dir='{save_path}/{team}-net' build-server-full '{team}-server' nopass"))
    print(subprocess.getoutput(f"./easyrsa/easyrsa --batch --pki-dir='{save_path}/{team}-net' gen-dh"))