#!/usr/bin/env python3
import os
import sys
import base64

FLAG_PLACEHOLDER = "ECSC{fake_flag_fake_flag_fake_flaaaaaaaaag}"
FLAG = os.environ.get("FLAG", FLAG_PLACEHOLDER)
with open("/home/user/flag.img", "rb") as fd:
    FLAG_IMG = fd.read()

FLAG_IMG = FLAG_IMG.replace(FLAG_PLACEHOLDER.encode(), FLAG.encode())

with open("/home/user/tmp/flag.img", "wb") as fd:
    fd.write(FLAG_IMG)

path = f"/home/user/tmp/{os.urandom(16).hex()}"

encoded_len = int(input("b64 encoded expl len: "))

print("b64 encoded expl: ", end = '', flush = True)
encoded_expl = sys.stdin.read(encoded_len)
print(encoded_expl)

try:
    expl = base64.b64decode(encoded_expl)
except:
    print("Error during b64 decode")
    sys.exit(1)

if len(expl) > 0x400000:
    print("Expl must be < 4Mb")
    sys.exit(1)

with open(path, "wb") as f:
    print(path)
    f.write(expl)

cmd = "/home/user/run.sh"
os.execv(cmd, [cmd, path])
