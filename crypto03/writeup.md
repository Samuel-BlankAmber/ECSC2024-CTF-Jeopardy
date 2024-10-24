# ECSC 2024 - Jeopardy

## [crypto] Smithing contest (2 solves)

Ok, so, I didn't read the part about this being a *cryptography* competition - my bad.
Now it's too late to back out though, please help me figure this out!

note: it is recommended to use sagemath-10.4 to run the challenge locally, due to performance reasons.

*The timeout on the remote is 120 seconds.*

`nc smithing.challs.jeopardy.ecsc2024.it 47012`

Author: Francesco Felet <@PhiQuadro>

## Overview

This challenge implements Han et al.’s ID-based Confirmer (Undeniable) Signature Scheme, a description of which can be found in this [paper](https://eprint.iacr.org/2003/129.pdf). The scheme has been slightly modified to make it work with type-3 pairing-friendly elliptic curves.

Undeniable signatures are digital signatures that cannot be verified without interacting with the signer. The scheme makes use of a Private Key Generator (the asymmetric analogue of a Key Distribution Center) to generate public parameters and distributing private keys to users, while the public keys are simply (a proper public function evaluated on) their ID (a bitstring).

The challenge objective is to forge a signature for the user `admin`.

## Solution

There isn't a lot of interaction with the server: we can register a user (different from `admin`, obviously) and get our private key, then we must provide our forgery to get the flag.

Unless one manages to find a username which corresponding public key (and hence the private one) collides with the admin's (which isn't really feasible), the only alternative is to find some combinations of public inputs that satisfy the two verification conditions:

$$
\begin{aligned}
                                  e(R, S)^x &= e(Q, Q_{id})^x \cdot r ^ {H(m) y^{-1}} \\
r ^ {y^{-1}} \cdot t^x \cdot e(P_{G_{1}}, Q_{id})^x &= e(R + Q, P_{G_{2}})^x
\end{aligned}
$$

Notice that $P_{G_{1}}$ and $P_{G_{2}}$ have the same discrete logarithm w.r.t. respectively $G_{1}$ and $G_{2}$: they are "equivalent" for all intents and purposes in our setting, therefore $P$ will be used for both of them in the rest of the writeup.

Recall that (after providing the signature $(R, S)$) the verifier sends us $C = xyR$, which is our only source of information on $x, y$.

One could try to trivialize the verification equations setting $r = 1$, but that won't work since the verifier (expecting $r, t$ as results of pairings) checks that they belong to a subgroup of $F_{p^{12}}^{*}$ of the correct order.

If we to express $R$ and $S$ as linear combinations of the available data the equations become really messy quite quickly, but we have a lot of control (i.e. $t$ is a free variable which can be used to adjust the second equation), therefore we can try to construct a simpler solution (focusing on the first equation).

If we expand the equations (using bilinearity) until we obtain some expression involving only pairings calculated on $P, R, S$ and $Q_{id}$, we end up with:

$$
\begin{aligned}
                                  e(R, S)^x &= e(P, Q_{id})^{sx} \cdot r ^ {H(m) y^{-1}} \\
r ^ {y^{-1}} \cdot t^x \cdot e(P, Q_{id})^x &= e(R, P)^x \cdot e(P, P)^{sx}
\end{aligned}
$$

We can notice that $y^{-1}$ appears only as an exponent of $r$, so we can try to eliminate that setting $r$ as the result of some pairing computation involving $C$, for example $r = e(C, P) = e(R, P)^{xy}$. The equations become:

$$
\begin{aligned}
                                  e(R, S)^x &= e(P, Q_{id})^{sx} \cdot e(R, P) ^ {H(m) x} \\
e(R, P)^{x} \cdot t^x \cdot e(P, Q_{id})^x &= e(R, P)^x \cdot e(P, P)^{sx}
\end{aligned}
$$

We can leverage $S$ (which appears only in the first equation) to get rid of $H(m)$. If we set $S = H(m)P$ though we get:

$$
e(R, P)^{H(m)x} = e(P, Q_{id})^{sx} \cdot e(R, P) ^ {H(m) x}
$$

and we cannot eliminate the first term of the right hand side. To account for that we can set $R = Q = sP$ and $S = Q_{id} + H(m)P$:

$$
\begin{aligned}
e(R, Q_{id} + H(m)P)^{x}                &= e(P, Q_{id})^{sx} \cdot e(R, P) ^ {H(m) x} \\
e(R, Q_{id})^{x} \cdot e(R, H(m)P)^{x}  &= e(P, Q_{id})^{sx} \cdot e(R, P) ^ {H(m) x} \\
e(P, Q_{id})^{sx} \cdot e(R, P)^{H(m)x} &= e(P, Q_{id})^{sx} \cdot e(R, P) ^ {H(m) x}
\end{aligned}
$$

which is always satisfied. Now it is just a matter of setting an appropriate $t$ to satisfy the second equation which is:

$$
\begin{aligned}
e(R, P)^{x} \cdot t^x \cdot e(P, Q_{id})^x &= e(R, P)^x \cdot e(P, P)^{sx} \\
t^x \cdot e(P, Q_{id})^x &= e(P, P)^{sx} \\
t^x \cdot e(P, Q_{id})^x &= e(Q, P)^{x}
\end{aligned}
$$

Therefore setting $t = e(Q, P) \cdot e(P, Q_{id})^{-1}$ is sufficient to get the flag.

## Exploit

```python
#!/usr/bin/env sage
from random import SystemRandom
from hashlib import sha256
from json import loads, dumps
from pwn import remote, process

LOCAL = False

if LOCAL:
    host, port = 'localhost', '47012'
else:
    host, port = 'smithing.challs.jeopardy.ecsc2024.it', '47012'

def intify(x):
    return list(map(int, x))

def strify(x):
    return list(map(str, x))

class BN:
    def __init__(self):
        self.p      = 239019556058548081539763731767358519973
        self.Fp     = GF(self.p)
        self.b      = 11
        self.EFp    = EllipticCurve(self.Fp, [0, self.b])
        self.O_EFp  = self.EFp([0, 1, 0])
        self.G1     = self.EFp((1, 133660577740454676305948404600566797994))
        self.t      = self.EFp.trace_of_frobenius()
        self.n      = self.EFp.order()
        self.k      = 12
        self.bits   = ZZ(self.p).nbits()
        self.bytes  = ceil(self.bits/8)

        Fp2.<a>     = GF(self.p^2)
        self.Fp2    = Fp2
        self.eps    = 50853858759521010453592688907791911225*a + 156893423039651253351316307339945502422
        self.EFp2   = EllipticCurve(self.Fp2, [0, self.b/self.eps])
        self.O_EFp2 = self.EFp2([0, 1, 0])
        self.G2     = self.EFp2((100774561144590475569157120930767342387*a + 218728496724280042701446122970647661523, 115367896606755692925113233629944781384*a + 211093354487559124632805793736258741445))
        self.h      = self.EFp2.order()//self.n

        Fp2u.<u>    = self.Fp2[]
        Fp12.<z>    = (u^6 - self.eps).root_field()
        self.Fp2u   = Fp2u
        self.Fp12   = Fp12
        self.z      = z
        self.EFp12  = EllipticCurve(self.Fp12, [0, self.b])

    def phi(self, P):
        assert P in self.EFp2 and P != self.O_EFp2 and self.n*P == self.O_EFp2, f'Point {P} not in <G2>'
        Px, Py = P.xy()
        return self.EFp12(self.z^2 * Px, self.z^3 * Py)

    def e(self, P, Q):
        assert P in self.EFp  and P != self.O_EFp, f'Point {P} not in <G1>'
        assert Q in self.EFp2 and Q != self.O_EFp2 and self.n*Q == self.O_EFp2, f'Point {Q} not in <G2>'
        return self.EFp12(P).ate_pairing(self.phi(Q), self.n, self.k, self.t, self.p)

class User:
    def __init__(self, params, sk, uid):
        self.curve = BN()
        self.r     = SystemRandom()
        self.p     = self.curve.n

        self.P_G1, self.Q = [self.curve.EFp(params[k]) for k in ['P_G1', 'Q']]
        self.P_G2         = self.curve.EFp2(params['P_G2'])

        self.sk  = tuple(map(self.curve.EFp2, sk))
        self.Qid = self.H0(uid)

    def rng(self):
        return self.r.randrange(self.p)

    def H(self, x):
        return int.from_bytes(sha256(x).digest()[:self.curve.bytes], 'big') % self.p

    def H0(self, uid):
        x0 = int.from_bytes(sha256(uid.encode()).digest(), 'big') % self.curve.p
        while 1:
            x0 += 1
            try:
                P = self.curve.h * self.curve.EFp2.lift_x(x0)
                if P != self.curve.O_EFp2 and self.p * P == self.curve.O_EFp2:
                    Px, Py = P.xy()
                    return self.curve.EFp2((Px, -Py)) # yeah, sage 9.5
            except:
                continue

    def sign(self, m):
        k = self.rng()
        R = k * self.P_G1
        S = int(pow(k, -1, self.p)) * self.sk[0] + self.H(m.encode()) * self.sk[1]
        R, S = intify(R.xy()), strify(S.xy())
        return (R, S)

    def init_verification(self, role, sig, m, Qid_signer):
        self.role, self.verification_step = role.lower(), 0
        self.x, self.y, self.y_inv = None, None, None
        self.sig = {'R': self.curve.EFp(sig[0]), 'S': self.curve.EFp2(sig[1]), 'm': m.encode(), 'Qid': Qid_signer}
        self.verifying = True
        return

    def verify(self, **kwargs):
        assert self.verifying

        if self.role == 'verifier':
            if self.verification_step == 0:
                self.x, self.y = [self.rng() for _ in range(2)]
                self.y_inv = int(pow(self.y, -1, self.p))
                C = self.x * self.y * self.sig['R']
                C = intify(C.xy())
                self.verification_step += 1
                return C

            elif self.verification_step == 1:
                assert 't' in kwargs and 'r' in kwargs
                t, r = kwargs['t'], kwargs['r']
                t, r = list(map(self.curve.Fp12, [t, r]))

                lhs0 = self.curve.e(self.sig['R'], self.sig['S']) ^ self.x
                rhs0 = self.curve.e(self.Q, self.sig['Qid']) ^ self.x * \
                       r ^ (self.H(self.sig['m']) * self.y_inv)

                lhs1 = r ^ self.y_inv * \
                       t ^ self.x     * \
                       self.curve.e(self.P_G1, self.sig['Qid']) ^ self.x
                rhs1 = self.curve.e(self.sig['R'] + self.Q, self.P_G2) ^ self.x

                self.verifying = False
                if lhs0 == rhs0 and lhs1 == rhs1:
                    return True
                return False

        elif self.role == 'signer':
            assert 'C' in kwargs
            C = self.curve.EFp(kwargs['C'])
            t = self.curve.e(self.sig['R'] + self.Q, self.P_G2 - self.sk[1])
            r = self.curve.e(C, self.sk[1])
            t, r = strify([t, r])
            self.verifying = False
            return t, r

with remote(host, port) as chall:
    chall.recvline()
    params = loads(chall.recvline(False).decode())
    print(f'[+] received params')

    uname = 'phi'
    chall.sendlineafter(b'username: ', uname.encode())
    chall.recvline()
    sk0 = loads(chall.recvline(False).decode())
    sk1 = loads(chall.recvline(False).decode())
    sk = (sk0, sk1)

    user = User(params, sk, uname)
    print(f'[+] registered')

    target = f'I, the eternal Admin, keeper of all secrets, hereby decree that you, {uname}, are worthy to glimpse my deepest and most ancient secret: the flag.'

    admin_Qid = user.H0('admin')
    R = user.Q
    S = admin_Qid + user.H(target.encode()) * user.P_G2

    sig = (intify(R.xy()), strify(S.xy()))
    chall.sendline(dumps(sig).encode())
    chall.sendline(target.encode())
    chall.sendline(b'admin')
    C = user.curve.EFp(loads(chall.recvline(False).decode().split('C = ')[-1]))
    print(f'[+] got {C = }')

    r = user.curve.e(C, user.P_G2)
    t = user.curve.e(user.Q, user.P_G2) * (user.curve.e(user.P_G1, admin_Qid) ^ -1)
    print(f'[+] crafted (t, r), sending..')

    tr = strify([t, r])
    chall.sendline(dumps(tr).encode())

    print(chall.recvline(False).decode().split()[-1])
```
