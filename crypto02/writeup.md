# ECSC 2024 - Jeopardy

## [crypto] RSATogether (8 solves)

RSA is cool, but I don't wanna do it alone. I found a way to do RSA together with my friends.

_The timeout on the remote is 60 seconds._

`nc rsatogether.challs.jeopardy.ecsc2024.it 47001`

Author: Lorenzo Demeio <@Devrar>

## Overview

The challenge implements a Shamir's Secret Sharing of an RSA private exponent $d$. The user can ask multiple times for a reshare of the key, selecting the number of friends to share it with.

The polynomial $p$ used to compute the shares is generated one time at the beginning as

```py
poly = [d] + [random.getrandbits(n_bits) for _ in range(99)]
```

Let's write $p$ as $p = d + a_1x + \ldots + a_{99}x^{99}$. When the secret is shared between $k$ people, $p$ is truncated to $k$ coefficients as $p_k = d + a_1x + \ldots + a_{k-1}x^{k-1}$. Then the shares are computed as $s_i \equiv c_ip_k(i) \mod\varphi(n)$ for $i \in \{1,\ldots,k\}$, where $c_i$ are computed such that $\sum_i c_ip_k(i) \equiv d \mod \varphi(n)$.

Finally, the user is given the share $s_{k-1}$.

## Solution

Even though the polynomial $p$ has $100$ coefficients, the user can ask for a reshare with $k$ shares with $2 \leq k \leq 102$, which are $101$ possibilities. Writing explicitly the user share, we get

$$
s_{k-1} \equiv c_{k-1}\sum_{i=0}^{k-1}a_i(k-1)^i \mod \varphi(n)
$$

where $a_0 = d$. Let's now consider the matrix $M$ over $\mathbb{Z}$ of dimension $101 \times 100$ where the $k$-th row is

$$
M_k = c_{k}\cdot \left(1, k, k^2, \ldots, k^{k}, 0, \ldots, 0\right).
$$

Since $M$ has dimension $101 \times 100$, its left kernel is not trivial. Let $v = (v_1, \ldots, v_{101})$ be a vector in its left kernel different from $0$. Now, calling $a = (a_0, \ldots, a_{99})$ the vector of coefficients of $p$, we have $s_k \equiv M_k \cdot a \mod \varphi(n)$.

Thus

$$
\sum_{k=1}^{101} v_k\cdot s_k \equiv \sum_{k=1}^{101} v_k \cdot M_k \cdot a \equiv \left(\sum_{k=1}^{101} v_k \cdot M_k\right) \cdot a \equiv (v\cdot M) \cdot a \equiv 0 \mod \varphi(n).
$$

So, by asking $101$ reshares with $2 \leq k \leq 102$, we can compute $m = \sum_{k=1}^{101} v_k\cdot s_k$ which is a multiple of $\varphi(n)$ and obtain an equivalent $d_1$ as `d1 = pow(e, -1, m)` satisfying $d_1 \equiv d \mod \varphi(n)$. With $d_1$ we can easily get the flag as `flag = pow(enc_flag, d1, n)`.

## Exploit

This is the script to compute the kernel vector $v$.

```py
import json

def get_coeff(n_shares):
    M = matrix(ZZ, [[x**i for i in range(n_shares)] for x in range(1, n_shares+1)])
    coeffs = M.solve_left(vector(ZZ, [1] + [0]*(n_shares - 1)))
    return coeffs[n_shares-2]

def build_M():
    m = []
    for n_shares in range(2, 101):
        c = get_coeff(n_shares)
        row = c*vector(ZZ, [(n_shares - 1)**i for i in range(n_shares)] + [0]*(100 - n_shares))
        m.append(row)
    c = get_coeff(101)
    m.append(c*vector(ZZ, [(100)**i for i in range(100)]))
    c = get_coeff(102)
    m.append(c*vector(ZZ, [(101)**i for i in range(100)]))

    return matrix(ZZ, m)

M = build_M()
coeffs = M.left_kernel().basis()[0]
assert all(x in ZZ for x in coeffs)

with open("coeffs.json", "w") as wf:
    wf.write(json.dumps([int(x) for x in list(coeffs)]))
```

This is the script for the second part of the solution.

```py
from pwn import remote
from Crypto.Util.number import long_to_bytes

import sys
sys.set_int_max_str_digits(5000)

HOST = os.environ.get("HOST")
PORT = int(os.environ.get("PORT"))

def share(n_shares, init=False):
    if not init:
        chall.sendlineafter(b"> ", b"2")
    chall.sendlineafter(b"? ", str(n_shares).encode())
    s = int(chall.recvline().decode().split(": ")[1])

    return s

with open('coeffs.json') as rf:
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
```
