# ECSC 2024 - Jeopardy

## [crypto] Quo vadis? (1 solve)

Do algebraic ducks go "quo quo"?

_The timeout on the remote is 600 seconds._

`nc quovadis.challs.jeopardy.ecsc2024.it 47000`

Author: Robin Jadoul <@robinjadoul>

## Overview

After reading and interpreting all manipulations happening in sage, we can conclude the following:

- The challenge (repeatedly) generates two random Galois rings modulo $2^k$.
- We get a value in one ring, and input one in the other.
- Then we get an evaluation (of some unknown ternary polynomial) of our input and have to guess the evaluation of the same polynomial in the first value.
- The two constructed rings always have identical total degree.

## Solution

Our approach will be to construct the isomorphism between the two rings, so that we can
move give the equivalent input (resp. output) in the other ring.
The general strategy to find an isomorphism of Galois rings (similarly to Galois fields)
is to factor the defining polynomial of one ring in the other, such that any root uniquely
defines the morphism.
That is, given the ring $` R_1 = \mathbb{Z}_{2^k}[X]/\langle f(X) \rangle = \mathbb{Z}_{2^k}[\zeta]`$, where $`f(\zeta) = 0`$ and the ring $` R_2 = \mathbb{Z}_{2^k}[X]/\langle g(X) \rangle `$,
we could factor $`f(X)`$ over $`R_2`$ and find $`\varphi(\zeta)`$ for the morphism $`\varphi`$ embedding $`R_1`$ into $`R_2`$, which in turn defines all of $`\varphi`$, as all values in $`\mathbb{Z}_{2^k}`$
should remain fixed and $`\varphi`$ is a morphism of rings.

In this challenge however, this is not quite enough yet, since we have a tower of multiple such extensions, and we cannot simply find an "equivalent" single defining polynomials,
and factoring in one of these towers is also painful.
Instead, we shall define a third isomorphic ring $`R_c`$, with a canonical choice of defining polynomial, such that we can find the isomorphisms $` \varphi : R_1 \to R_c `$ and $` \psi : R_2 \to R_c `$ between our
two random extensions and $`R_c`$ individually, and compose them appropriately to find the isomorphism $` \chi = \psi^{-1}\circ\varphi `$ and its inverse.

The last remaining question is then of course how to find $`\varphi`$ and $`\psi`$.
We can attack the towers layer per layer, where we can first embed the defining polynomial (defined over the lower layer) into $`R_c`$ before factoring it
and extending our homomorphism (that embeds the subring into $`R_c`$) to the next layer.
Once the entire tower has been processed in this way, the subring is equal to $`R_c`$ itself and hence we have an isomorphism.
To take these combinations of homomorphisms in the tower, and to find the final inverse isomorphism, we make use of the fact
that the homomorphisms are $`\mathbb{Z}_{2^k}`$-linear and take a look at the matrix representation.
To factor a polynomial over $`R_c`$ efficiently, we can ask sage to find a root over $`\mathbb{F}_{2^d}`$ first, and then
make use of Hensel's lift to iteratively increase the number of bits in the representation.
Alternatively, sage can make use of "unramified extensions of the 2-adics" to do this for us, with some magic :)

## Exploit

```py
from pwn import *
import hashlib
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
import logging

logging.disable()


proof.all(False)


def recv_modulus(depth, d, subring):
    ctx = {}
    Rb = subring
    for i in range(depth - 1, -1, -1):
        ctx[f"b{i}bar"] = Rb.gen()
        Rb = Rb.base_ring()
    PR = subring[f"b{depth}"]
    ctx[f"b{depth}"] = PR.gen()
    mod_s = io.recvline().decode().strip()
    mod = eval(preparse(mod_s), globals() | ctx)
    assert mod.parent() is PR
    return PR.quo(mod)


def tolist(pt):
    R = pt.parent()
    B = R.base_ring()
    if R is B:
        yield int(pt)
    else:
        for e in pt.list():
            yield from tolist(e)


def fromlist(R, xs, d=None):
    B = R.base_ring()
    if d is None:
        d = R.degree()
    if B is R:
        return R(next(xs))
    return R([fromlist(B, xs) for _ in range(d)])


def get_root_magic(p, R):
    assert p in R['x']
    # Sage magic follows, you can do a Hensel lift instead ;)
    padic.<a> = Zq(2^R.degree(), R.base_ring().cardinality().bit_length() - 1, modulus=R.modulus())
    pp = padic['x']([c.lift().change_ring(padic)(x = a) for c in p.list()])
    root = pp.any_root().polynomial().lift()(x = R.gen())
    assert p(root) == 0
    return root


# Ugly Hensel lift, sage is slow as usual, so if you really want to go fast, might need a bunch of extra work
def lift(orig_f, r1, k, Rl):
    old = r1
    kk = 1
    while kk < k:
        print(",", end="", flush=True)
        Rw = Zmod(2^(2*kk))
        Rwl = Rw.extension(Rl.modulus())
        f = Rwl['y']([Rwl([Rw(t) for t in c.list()]) for c in orig_f.list()])
        PRw = PolynomialRing(Rw, 'z', Rl.degree())
        PRl = PRw.extension(Rl.modulus())
        M = 2^kk
        r2_symbolic = PRl([PRw.gens()[i] * M + Rw(old[i]) for i in range(Rl.degree())])
        should_be_zero = PRl['y']([PRl(c.list()) for c in f.list()])(r2_symbolic)
    
        M = Matrix(Zmod(2^kk), [[ZZ(c.coefficient({g:1})) // (2^kk) for g in PRw.gens()] for c in should_be_zero.list()])
        b = vector(Zmod(2^kk), [ZZ(-c.constant_coefficient())//(2^kk) for c in should_be_zero.list()])
        z_assignment = M.solve_right(b).change_ring(Rw)

        r2 = Rwl([x.subs({g:ZZ(a) for g, a in zip(PRw.gens(), z_assignment)}) for x in r2_symbolic.list()])
        assert f(r2) == 0

        old = r2
        kk <<= 1
    return old

def get_root_hensel(p, R):
    assert p in R['x']
    F = GF(2^R.degree(), name="ζ", modulus=R.modulus().change_ring(GF(2)))
    f = F['x']([F(c.lift().change_ring(GF(2))) for c in p.list()])
    r1 = f.any_root()
    assert all(c % 2 == 0 for c in p(R([int(c) for c in r1.list()])).list())
    root = lift(p, r1, R.base_ring().cardinality().bit_length() - 1, R)
    root = R(root.list())
    assert p(root) == 0
    return root


get_root = get_root_magic

def rand(R, d = None):
    import secrets
    B = R.base_ring()
    if d is None:
        d = R.degree()
    if B is R:
        return R(secrets.randbits(R.cardinality().nbits() - 1))
    else:
        return R([rand(B) for _ in range(d)])
def test_embedding(φ, r1, r2):
    return # Comment for actual (slowish) testing
    for _ in range(1000):
        a = rand(r1)
        b = rand(r1)
        c = φ(a)
        d = φ(b)
        assert c.parent() is d.parent() is r2
        assert φ(a + b) == c + d
        assert φ(a * b) == c * d
        assert φ(-a) == -c
    print("OK")


def make_iso(Rs, R):
    # At first, we only know how to map the lowest level shared ring
    φ = lambda x: x
    columns = [R(1)]
    for r in Rs[1:]:
        print(".", end="", flush=True)
        embedded_mod = R['x']([φ(c) for c in r.modulus().list()])
        embedding = get_root(embedded_mod, R)
        new_columns = []
        for i in range(r.degree()):
            power = embedding^i
            new_columns.extend([c * power for c in columns])
        columns = new_columns
        M = Matrix.column([c.list() for c in columns])
        φ = (lambda M: lambda x: fromlist(R, iter(M * vector(tolist(x)))))(M)
        test_embedding(φ, r, R)
    print()
    # φ: Rs[-1] -> R
    # φ_inv: R -> Rs[-1]
    φ_inv = (lambda M: lambda x: fromlist(Rs[-1], iter(M * vector(tolist(x)))))(M^-1)
    test_embedding(φ_inv, R, Rs[-1])
    return φ, φ_inv


def chal(k, d1s):
    info("%s %s %s", k, d1s, prod(d1s))
    R1 = R2 = Zmod(2^k)
    R1s = [R1]
    R2s = [R2]
    for i, d1 in enumerate(d1s):
        R1s.append(recv_modulus(i, d1, R1s[-1]))
    for i, d2 in enumerate([prod(d1s)]):
        R2s.append(recv_modulus(i, d2, R2s[-1]))
    info("parsed")
    R = Zmod(2^k)['x'].quo(GF(2^prod(d1s), name="ζ", modulus="minimal_weight").modulus().change_ring(Zmod(2^k)))
    info("constructed R")
    R1 = R1s[-1]
    φ, φ_inv = make_iso(R1s, R)
    R2 = R2s[-1]
    ψ, ψ_inv = make_iso(R2s, R)
    χ = lambda x: ψ_inv(φ(x))
    χ_inv = lambda x: φ_inv(ψ(x))
    test_embedding(χ, R1, R2)
    test_embedding(χ_inv, R2, R1)
    base = fromlist(R1, (int(x) for x in io.recvline().decode().strip().split(",")))
    io.sendlineafter(b"> ", ",".join(map(str, tolist(χ(base)))).encode())
    result = fromlist(R2, (int(x) for x in io.recvline().decode().strip().split(",")))
    K.extend(tolist(χ_inv(result)))


HOST = os.environ.get("HOST", "localhost")
PORT = int(os.environ.get("PORT", 1337))

# io = process(["sage", "src/chall.sage"])
io = remote(HOST, PORT)
K = []
chal( 2, [2, 3]   )
chal( 8, [2, 3]   )
chal( 8, [2, 3, 5])
chal(32, [3, 4, 5])
chal(64, [4, 3, 5])
iv, ct = io.recvline().strip().decode().split()
key = hashlib.sha256("||".join(map(str, K)).encode()).digest()
cipher = AES.new(key, AES.MODE_CBC, iv=bytes.fromhex(iv))
print(unpad(cipher.decrypt(bytes.fromhex(ct)), AES.block_size).decode())
```
