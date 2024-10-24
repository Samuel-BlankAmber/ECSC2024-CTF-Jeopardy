#!/usr/bin/env sage
from random import SystemRandom
from hashlib import sha256
from json import loads, dumps
from pwn import remote, process

LOCAL = True

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
    t = user.curve.e(R + user.Q, user.P_G2) * (user.curve.e(user.P_G1, admin_Qid) ^ -1) * (user.curve.e(user.Q, user.P_G2) ^ -1)
    print(f'[+] crafted (t, r), sending..')

    tr = strify([t, r])
    chall.sendline(dumps(tr).encode())

    print(chall.recvline(False).decode().split()[-1])
