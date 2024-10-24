#!/usr/bin/env python3

import json
import os
import logging
logging.disable()

from pwn import remote
from Crypto.Util.number import long_to_bytes

import sys
sys.set_int_max_str_digits(5000)

HOST = os.environ.get("HOST", "rsatogether.challs.jeopardy.ecsc2024.it")
PORT = int(os.environ.get("PORT", 47001))

def share(n_shares, init=False):
    if not init:
        chall.sendlineafter(b"> ", b"2")
    chall.sendlineafter(b"? ", str(n_shares).encode())
    s = int(chall.recvline().decode().split(": ")[1])

    return s

with open(os.path.join(os.path.dirname(__file__), 'coeffs.json')) as rf:
    coeffs = json.loads(rf.read())

with remote(HOST, PORT) as chall:
    n = int(chall.recvline().decode().split(" = ")[1])
    e = int(chall.recvline().decode().split(" = ")[1])
    s1 = share(1, init=True)

    shares = []
    for i in range(1, 102):
        s = share(i)
        shares.append(s)

    mul_phi = sum(c*s for c,s in zip(coeffs, shares))
    d = pow(e, -1, mul_phi)

    chall.sendlineafter(b"> ", b"3")
    chall.recvline()
    enc_flag = int(chall.recvline().decode())
    flag = long_to_bytes(pow(enc_flag, d, n))
    flag = flag[flag.index(b"ECSC{"):].decode()

    print(flag)
