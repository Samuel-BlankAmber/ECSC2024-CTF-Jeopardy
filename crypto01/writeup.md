# ECSC 2024 - Jeopardy

## [crypto] OffTopic (30 solves)

Did you know that you only need FHE to build OT?

_The timeout on the remote is 60 seconds._

`nc offtopic.challs.jeopardy.ecsc2024.it 47013`

Author: Riccardo Zanotto <@Drago>

## Overview

This challenge implements an _oblivious transfer_ (OT) protocol via a linearly homomorphic encryption scheme such as ElGamal.

In particular, the client should receive _exactly one_ between $m_0$ and $m_1$, depending on its choice bit $b$; notice that an answer of $(1-b)\cdot m_0 + b\cdot m_1$ reveals exactly the intended value.

The intended use of the client is to encrypt its choice bit $b$ into an ElGamal ciphertext $c=(R, S)$, where $R=rG, S=rH+bG$. Since the sum of two ElGamal ciphertexts encrypts the sum of the underlying messages, the server can compute the quantity $(1-c)\cdot m_0 + c\cdot m_1$ that will encrypt the correct message.

## Solution

The vulnerability in this protocol is in the fact that the ciphertext $c$ sent by the client is not forced to be an encryption of 0 or 1, but could be anything.

In particular, if we choose $b=10$, and compute $c=\mathsf{Enc}(10)$, the decryption of the message obtained by the server will be $z=m_0+10(m_1-m_0)$.

Since $m_0,m_1\in[0,9]$, we can easily get $m_0=z\mod 10$, and then also $m_1$.

Notice that decryption requires computing a discrete logarithm, so it's very easy for $0$ and $1$ values, but anyways the quantity $z$ is bounded by $|z|\le 100$, so it's still easy.

## Exploit

```python
#!/usr/bin/env python3

from pwn import remote, process
from Crypto.PublicKey.ECC import EccPoint
from Crypto.Random import random
import json
import logging
import os

logging.disable()


# For TCP connection
HOST = os.environ.get("HOST", "offtopic.challs.jeopardy.ecsc2024.it")
PORT = int(os.environ.get("PORT", 47013))


p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
Gx = 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296
Gy = 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5
q = 0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551
G = EccPoint(Gx, Gy)


dlogs = {(0,0): 0}
cur = G
for i in range(1, 300):
    dlogs[(int(cur.x), int(cur.y))] = i
    dlogs[(int((-cur).x), int((-cur).y))] = -i
    cur = (cur+G)


def decrypt(sk, ct):
    val = ct[1] + sk*(-ct[0])
    return dlogs[int(val.x), int(val.y)]

def encrypt(H, m):
    R = G
    S = H + m*G
    return [R, S]

class Client:
    def __init__(self):
        self.r = remote(HOST, PORT)
        self.r.recvline()

    def send_pk(self, H):
        data = {"Hx": int(H.x), "Hy": int(H.y)}
        self.r.sendlineafter(b"key: ", json.dumps(data).encode())

    def send_ct(self, C):
        data = {"Rx": int(C[0].x), "Ry": int(C[0].y), "Sx": int(C[1].x), "Sy": int(C[1].y)}
        self.r.sendlineafter(b"bit: ", json.dumps(data).encode())
        res = json.loads(self.r.recvline(False).decode())
        R = EccPoint(res["Rx"], res["Ry"])
        S = EccPoint(res["Sx"], res["Sy"])
        return (R, S)

    def send_msg(self, m0, m1):
        data = {"m0": m0, "m1": m1}
        self.r.sendlineafter(b"messages: ", json.dumps(data).encode())

    def open_ct(self, m, r):
        data = {"m": m, "r": r}
        self.r.sendline(json.dumps(data).encode())

    def get_flag(self):
        return self.r.recvline(False).decode()


client = Client()
sk = random.randint(0, q-1)
H = sk*G
client.send_pk(H)
VAL = 10
ct = encrypt(H, VAL)

for _ in range(128):
    res = client.send_ct(ct)
    dec = decrypt(sk, res)
    m0 = dec % VAL
    m1 = (dec-m0)//VAL + m0
    client.send_msg(m0, m1)

flag = client.get_flag()
print(flag)
```
