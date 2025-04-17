from pwn import process
from json import loads, dumps
from Crypto.PublicKey.ECC import EccPoint
import random

p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
Gx = 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296
Gy = 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5
q = 0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551
G = EccPoint(Gx, Gy)

def get_random_ecc_point():
    return G * random.randint(0, q-1)

def get_pubkey_json(Hx, Hy):
    return dumps({"Hx": int(Hx), "Hy": int(Hy)})

def get_encrypted_bit_json(Rx, Ry, Sx, Sy):
    return dumps({"Rx": int(Rx), "Ry": int(Ry), "Sx": int(Sx), "Sy": int(Sy)})

def get_recovered_msgs_json(m0, m1):
    return dumps({"m0": m0, "m1": m1})

def get_res():
    res = io.recvline_startswith(b'{"Rx')
    res = loads(res.decode())
    return res["Rx"], res["Ry"], res["Sx"], res["Sy"]

io = process(["python3", "../src/chall.py"])

C_S = get_random_ecc_point()
m0_m1_to_Sx = {}
for m0 in range(10):
    for m1 in range(10):
          res_S = m0*(G + (-C_S)) + m1*(C_S)
          m0_m1_to_Sx[(m0, m1)] = int(res_S.x)

Sx_to_m0_m1 = {}
for (m0, m1), Sx in m0_m1_to_Sx.items():
    if Sx in Sx_to_m0_m1:
        raise ValueError(f"Non-unique Sx value detected: {Sx}")
    Sx_to_m0_m1[Sx] = (m0, m1)

io.sendlineafter(b"public key: ", get_pubkey_json(0, 0).encode())

for i in range(128):
    print("Round:", i+1)
    io.sendlineafter(b"encrypted choice bit: ", get_encrypted_bit_json(0, 0, C_S.x, C_S.y).encode())
    _, _, Sx, _ = get_res()
    m0, m1 = Sx_to_m0_m1[Sx]
    io.sendlineafter(b"recovered messages: ", get_recovered_msgs_json(m0, m1).encode())

io.interactive()
