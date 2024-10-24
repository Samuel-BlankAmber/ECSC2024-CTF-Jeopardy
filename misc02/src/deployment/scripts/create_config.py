#!/usr/bin/env python3

from base58 import b58encode
import os
import json
import jinja2
import hmac

PRETTY_WG_CHALLENGE_NAME = 'trust'

NUMBER_OF_TEAMS = 37
TEAM_START_INDEX = 1

IP_RANGES = {
    "prefixes": {
        "icea": "10.253.2",
        "icep": "10.254.2",
        "router": "10.151.2",
    },
    "lab": "10.151.2.0/24",
    "players": "10.150.0.0/16",
    "mgmt": "10.250.0.0/16",
}

# In case of emergency (ICE) credentials
NUM_ICEP = 10 # players
NUM_ICEA = 2 # admins

CREDENTIALS = {
    "dca": "deploy",
    "dcb": "deploy",
    "pizza.local": ("Administrator", "DoughN0tFai1!"),
    "spaghetti.local": "Administrator",
}
SSH_KEYS = ['lab']
WG_KEYS = ['lab', 'team']

script_path = os.path.dirname(os.path.realpath(__file__))
deployment_path = os.path.join(script_path, "..")
challenge_root_dir = os.path.join(deployment_path, "..", "..")
config_path = os.path.join(deployment_path, "config")
ansible_dir = os.path.join(deployment_path, "ansible")
flag_placer_config_template = os.path.join(ansible_dir, "router", "files", "flag-placer", "config.json.template")
os.chdir(config_path)

def random_password():
    return b58encode(os.urandom(16)).decode() + "1!" # ensure password has at least 1 number and 1 special character

def generate_ssh_keys():
    os.makedirs("ssh_keys", exist_ok=True)
    os.remove("ssh_keys/lab") if os.path.exists("ssh_keys/lab") else None

    for key in SSH_KEYS:
        os.remove(f"ssh_keys/{key}.pub") if os.path.exists(f"ssh_keys/{key}.pub") else None
        os.system(f"ssh-keygen -t ed25519 -f ssh_keys/{key} -N '' -C '{key}'")

    ssh_keys = {key: { "priv": open(f"ssh_keys/{key}").read().strip(), "pub": open(f"ssh_keys/{key}.pub").read().strip() } for key in SSH_KEYS}

    return ssh_keys

def generate_wireguard_keys():
    os.makedirs("wg_keys", exist_ok=True)
    os.makedirs("wg_keys/icep", exist_ok=True)
    os.makedirs("wg_keys/icea", exist_ok=True)

    for key in WG_KEYS:
        os.remove(f"wg_keys/{key}_private") if os.path.exists(f"wg_keys/{key}_private") else None
        os.remove(f"wg_keys/{key}_public") if os.path.exists(f"wg_keys/{key}_public") else None
        os.system(f"wg genkey | tee wg_keys/{key}_private | wg pubkey > wg_keys/{key}_public")

    # In case of emergency (ICE) keys for players
    for i in range(1, NUM_ICEP + 1):
        os.remove(f"wg_keys/icep/{i}_private") if os.path.exists(f"wg_keys/icep/{i}_private") else None
        os.remove(f"wg_keys/icep/{i}_public") if os.path.exists(f"wg_keys/icep/{i}_public") else None
        os.system(f"wg genkey | tee wg_keys/icep/{i}_private | wg pubkey > wg_keys/icep/{i}_public")

    # In case of emergency (ICE) keys for admins
    for i in range(1, NUM_ICEA + 1):
        os.remove(f"wg_keys/icea/{i}_private") if os.path.exists(f"wg_keys/icea/{i}_private") else None
        os.remove(f"wg_keys/icea/{i}_public") if os.path.exists(f"wg_keys/icea/{i}_public") else None
        os.system(f"wg genkey | tee wg_keys/icea/{i}_private | wg pubkey > wg_keys/icea/{i}_public")

    icep = []
    for i in range(1, NUM_ICEP + 1):
        icep.append({ "priv": open(f"wg_keys/icep/{i}_private").read().strip(), "pub": open(f"wg_keys/icep/{i}_public").read().strip() })

    icea = []
    for i in range(1, NUM_ICEA + 1):
        icea.append({ "priv": open(f"wg_keys/icea/{i}_private").read().strip(), "pub": open(f"wg_keys/icea/{i}_public").read().strip() })

    wg_keys = {key: { "priv": open(f"wg_keys/{key}_private").read().strip(), "pub": open(f"wg_keys/{key}_public").read().strip() } for key in WG_KEYS}
    wg_keys["icep"] = icep
    wg_keys["icea"] = icea

    return wg_keys

def generate_credentials():
    return {key: { "username": CREDENTIALS[key][0], "password": CREDENTIALS[key][1] } if isinstance(CREDENTIALS[key], tuple) else { "username": CREDENTIALS[key], "password": random_password() } for key in CREDENTIALS}

def create_wg_configs(wg_keys):
    os.makedirs("wg_confs", exist_ok=True)
    os.makedirs("wg_confs/icep", exist_ok=True)
    os.makedirs("wg_confs/icea", exist_ok=True)

    env = jinja2.Environment(loader=jinja2.FileSystemLoader("wg_conf_templates"))

    for template in env.list_templates():
        template = env.get_template(template)
        filename = os.path.basename(template.filename)

        if filename.startswith("ice"):
            for i in range(1, (NUM_ICEA if "icea" in filename else NUM_ICEP) + 1):
                with open(f"wg_confs/{filename.replace('.conf', '')}/{filename.replace('ice', '').replace('.conf', '')}{i}{PRETTY_WG_CHALLENGE_NAME}.conf", "w") as f:
                    f.write(template.render(keys=wg_keys, ip_ranges=IP_RANGES, i=i))
        else:
            with open(f"wg_confs/{filename.replace('team', f't{PRETTY_WG_CHALLENGE_NAME}')}", "w") as f:
                f.write(template.render(keys=wg_keys, ip_ranges=IP_RANGES,num_icea=NUM_ICEA, num_icep=NUM_ICEP))

def create_flag_template():
    with open(os.path.join(deployment_path, "flag.txt"), "r") as f:
        flag = f.read().strip()

    flag_key = os.urandom(16).hex()
    flag_server_config = {
        "flagKey": flag_key,
        "flagTemplate": flag
    }

    team_flags = {}
    for team_id in range(TEAM_START_INDEX, TEAM_START_INDEX + NUMBER_OF_TEAMS):
        team_seed = hmac.new(flag_key.encode(), str(team_id).encode(), "sha256").hexdigest()[:8]
        team_flag = flag.replace("}", f"_{team_seed}}}")
        team_flags[team_id] = team_flag

    with open("flags.json", "w") as f:
        f.write(json.dumps(team_flags, indent=4))

    with open(os.path.join(challenge_root_dir, "flags.txt"), "w") as f:
        escape_flag = lambda flag: flag.replace("{", "\\{").replace("}", "\\}")
        f.write("\n".join([f"^{escape_flag(team_flags[team_id])}$" for team_id in team_flags]))
        f.write("\n")

    with open(flag_placer_config_template, "r") as f:
        template = jinja2.Template(f.read())
        with open(flag_placer_config_template.replace(".template", ""), "w") as f:
            f.write(template.render(flag_server_config))

    return flag_server_config

if __name__ == "__main__":
    wg_keys = generate_wireguard_keys()
    config = {
        "sshKeys": generate_ssh_keys(),
        "wgKeys": wg_keys,
        "credentials": generate_credentials(),
        "flag": create_flag_template(),
    }

    create_wg_configs(wg_keys)

    with open("config.json", "w") as f:
        f.write(json.dumps(config, indent=4))

    print(f"[*] Configuration created successfully to {os.path.normpath(os.path.join(config_path, 'config.json'))}")

    # Create a zip file of the config directory
    os.system("cd ..; rm -f ../config.zip; zip -q -r config.zip config")
    print("[*] Saved configuration to config.zip")