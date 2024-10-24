# ECSC 2024 - Jeopardy

## [crypto] One Round Crypto (0 solves)

It's just one round of encryption. How hard can it be?

_The timeout on the remote is 300 seconds._

`nc oneroundcrypto.challs.jeopardy.ecsc2024.it 47010`

Author: Matteo Rossi <@mr96>

## Overview

The challenge implements a single round symmetric cipher, with one linear mixing layer, a substitution layer and a second linear mixing layer. All these layers are key dependent, thus not entirely known to us. We are given a single encryption query, in ECB mode, with an unlimited number of blocks. After that we are asked to correctly decrypt 100 ciphertexts to get the flag.

## Solution

To get the flag we need to recover all the layers of the cipher, or a set of layers forming an equivalent cipher (this observation will be important later).

Let's call $M_1$ and $M_2$ the two $128 \times 128$ matrices over $`\mathbb{F}_2`$ representing the two mixing layers and $S = (S_1, \ldots, S_{16})$ the substition layer composed of 16 SBOXes. Then the encryption of a plaintext block $p \in \mathbb{F}_2^{128}$ is given by

$$
c = M_2 \cdot S(M_1 \cdot p)
$$

where $S()$ represents the application of each SBOX byte per byte. Writing $M_3 = M_2^{-1}$, we can decompose the previous equation as $M_3 \cdot c = S(M_1 \cdot p)$ or $M_{3,i} \cdot c = S_i(M_{1,i} \cdot p), \quad i \in \{1,\dots,16\}$ where $M_{j,i}$ is the $i$-th row of $M_j$.

Let's focus on the equation with $i = 1$. If we consider $p_1$ and $p_2$ such that $M_{1,1} \cdot p_1 = M_{1,1} \cdot p_2$ (which is the same as saying that $`p_1 + p_2 \in \ker(M_{1,1})`$) then

$$
S_1(M_{1,1} \cdot p_1) = S_1(M_{1,1} \cdot p_2)\\
\Rightarrow M_{3,1} \cdot c_1 = M_{3,1} \cdot c_2\\
\Rightarrow c_1 + c_2 \in \ker(M_{3,1}).
$$

Thus by generating enough pairs $p_1, p_2$ with this property, we can get the whole kernel of $M_{3,1}$. We can choose the plaintexts in a structured way so that we only have to guess one pair $p_1, p_2$ with $p_1 + p_2 \in \ker(M_{1,1})$. Let `P = [os.urandom(dim) for _ in range(128)]` and `C = [os.urandom(dim) for _ in range(128)]` and let's construct the plaintexts as $p_i + c_j$ for every $p_i \in P$ and $c_j \in C$. Then if $M_{1,1} \cdot p_1 = M_{1,1} \cdot p_2$ also $M_{1,1} \cdot (p_1 + c_i) = M_{1,1} \cdot (p_2 + c_i)$, hence we can generate $|C|$ pairs with this property. Since $M_{3,1}$ has dimension $8 \times 128$, its kernel will have dimension $120$. So we can easily check that we guessed a right pair $p_1, p_2$ by verifying that the corresponding ciphertexts are all in a subspace of dimension $120$. If so, we correctly retrieved the kernel of $M_{3,1}$. We can do the same for all 16 matrices $M_{3,i}$.

```py
zero_8 = vector(GF(2), [0]*8)
inv_mixing_2 = []
for i in range(len(P)):
    if len(inv_mixing_2) == dim:
        break
    for j in range(i+1,len(P)):
        try_ct = ct_chunks[i][0] + ct_chunks[j][0]
        if any(m2*try_ct == zero_8 for m2 in inv_mixing_2):
            continue
        M = []
        for k in range(len(C)):
            M.append(ct_chunks[i][k] + ct_chunks[j][k])
        M = Matrix(F, M)
        r = M.rank()
        if r == 8*(dim-1):
            m2 = matrix(M.right_kernel().basis())
            inv_mixing_2.append(m2)
            if len(inv_mixing_2) == dim:
                break
```

Once we have the kernel of $M_{3,1}$, we can make a similar argument to derive the kernel of $M_{1,1}$. Indeed let $\{v_1, \ldots, v_{16}\}$ be a basis of $\ker(M_{3,1})$. For every ciphertext $c$ we can check if it is in $\text{span}(\{v_1, \ldots, v_{16}\})$ hence in $\ker(M_{3,1})$. If we have two ciphertexts $c_1, c_2$ with this property, we have

$$
M_{3,1} \cdot c_1 = M_{3,1} \cdot c_2\\
S_1^{-1}(M_{3,1} \cdot c_1) = S_1^{-1}(M_{3,1} \cdot c_2)\\
\Rightarrow M_{1,1} \cdot p_1 = M_{1,1} \cdot p_2\\
\Rightarrow p_1 + p_2 \in \ker(M_{1,1})
$$

This way, finding enough elements of the kernel we can retrieve also the whole $\ker(M_{1,1})$ and the same for all $M_{1,i}$.

```py
mixing_1 = []
for m2 in inv_mixing_2:
    base_sub = matrix(m2.right_kernel().basis())
    base_pt = None
    cur_ker_pts = []
    for pt, ct in zip(random_pts, random_cts):
        if base_sub.stack(ct).rank() == 8*(dim-1):
            if not base_pt:
                base_pt = pt
            else:
                cur_ker_pts.append(pt + base_pt)
    M = matrix(GF(2), cur_ker_pts)
    print(f"{ M.nrows() = }")
    m1 = matrix(M.right_kernel().basis())
    print(f"{m1.nrows() = }")
    mixing_1.append(m1)
```

The kernel of one of these matrices does not immediately give us the whole matrix, but it retrieves it up to a base change, which can be view as a byte permutation before the matrix. Thus, we can embed this byte permutation in the SBOXes and, by choosing equivalent matrices $M_2'$ and $M_1'$, retrieve the corresponding set of SBOXes $S'$ for which we have an equivalent cipher. The equivalent SBOXes can be easily obtained by considering enough plaintext-ciphertext pairs, removing the mixing layers and constructing the lookup table.

```py
def retrieve_sbox():
    S = [{} for _ in range(dim)]
    for i in range(pairs):
        for pos in range(dim):
            S[pos][tuple(tmp1[i][pos])] = tmp2[i][pos]
    r = True
    for j in range(pairs, pairs+100):
        try:
            if all([S[pos][tuple(tmp1[j][pos])] == tmp2[j][pos] for pos in range(dim)]):
                pass
            else:
                r = False
                break
        except Exception as e:
            print([len(x) for x in S])
            r = False
            break
            pass
    if r:
        return S
```

## Exploit

```py
from pwn import remote, process

def xor(a,b):
    return bytes([x^^y for x,y in zip(a,b)])

dim = 16
num_rand_pts = 2**15 + 2**10
P = [os.urandom(dim) for _ in range(128)]
C = [os.urandom(dim) for _ in range(128)]
random_pts = [os.urandom(dim) for _ in range(num_rand_pts)]
query = ""
for el in P:
    for m in C:
        query += xor(el,m).hex()
for pt in random_pts:
    query += pt.hex()

HOST = os.environ.get("HOST", "localhost")
PORT = int(os.environ.get("PORT", 1337))

chall = remote(HOST, PORT)
chall.recvuntil(b"> ")
chall.sendline(query.encode())
res = chall.recvline().strip().decode()
pt_chunks = []
ct_chunks = []
random_pts = []
random_cts = []
print("Done connection")
F = GF(2)

for a in range(len(P)):
    tmp = []
    tmp2 = []
    for b in range(len(C)):
        tmp.append(vector(F, Integer(query[a*dim*2*len(C)+b*dim*2:][:dim*2],16).digits(base=2, padto=8*dim)))
        tmp2.append(vector(F, Integer(res[a*dim*2*len(C)+b*dim*2:][:dim*2],16).digits(base=2, padto=8*dim)))
    pt_chunks.append(tmp)
    ct_chunks.append(tmp2)

for i in range(num_rand_pts):
    random_pts.append(vector(F, Integer(query[len(P)*dim*2*len(C) + i*dim*2:][:dim*2],16).digits(base=2, padto=8*dim)))
    random_cts.append(vector(F, Integer(res[len(P)*dim*2*len(C) + i*dim*2:][:dim*2],16).digits(base=2, padto=8*dim)))

print("Starting inv mixing 2")
zero_8 = vector(GF(2), [0]*8)
inv_mixing_2 = []
for i in range(len(P)):
    if len(inv_mixing_2) == dim:
        break
    for j in range(i+1,len(P)):
        try_ct = ct_chunks[i][0] + ct_chunks[j][0]
        if any(m2*try_ct == zero_8 for m2 in inv_mixing_2):
            continue
        M = []
        for k in range(len(C)):
            M.append(ct_chunks[i][k] + ct_chunks[j][k])
        M = Matrix(F, M)
        r = M.rank()
        if r == 8*(dim-1):
            m2 = matrix(M.right_kernel().basis())
            inv_mixing_2.append(m2)
            if len(inv_mixing_2) == dim:
                break

print("Starting inv mixing 1")
mixing_1 = []
for m2 in inv_mixing_2:
    base_sub = matrix(m2.right_kernel().basis())
    base_pt = None
    cur_ker_pts = []
    for pt, ct in zip(random_pts, random_cts):
        if base_sub.stack(ct).rank() == 8*(dim-1):
            if not base_pt:
                base_pt = pt
            else:
                cur_ker_pts.append(pt + base_pt)
    M = matrix(GF(2), cur_ker_pts)
    print(f"{ M.nrows() = }")
    m1 = matrix(M.right_kernel().basis())
    print(f"{m1.nrows() = }")
    mixing_1.append(m1)

mixing_1 = [Matrix(F, m1) for m1 in mixing_1]

pairs = 5000
tmp1 = []
tmp2 = []
for pt,ct in zip(random_pts[:pairs+100],random_cts[:pairs+100]):
    tmp1.append([m1 * pt for m1 in mixing_1])
    tmp2.append([m2 * ct for m2 in inv_mixing_2])


def retrieve_sbox():
    S = [{} for _ in range(dim)]
    for i in range(pairs):
        for pos in range(dim):
            S[pos][tuple(tmp1[i][pos])] = tmp2[i][pos]
    r = True
    for j in range(pairs, pairs+100):
        try:
            if all([S[pos][tuple(tmp1[j][pos])] == tmp2[j][pos] for pos in range(dim)]):
                pass
            else:
                r = False
                break
        except Exception as e:
            print([len(x) for x in S])
            r = False
            break
            pass
    if r:
        return S

recovered_sboxes = retrieve_sbox()

inv_sboxes = [{} for _ in range(dim)]

for i in range(dim):
    for k in recovered_sboxes[i]:
        inv_sboxes[i][tuple(recovered_sboxes[i][k])] = vector(F, k)

chall.recvline()

if recovered_sboxes is not None:
    inv_mixing_1 = mixing_1[0]
    for i in range(1,dim):
        inv_mixing_1 = inv_mixing_1.stack(mixing_1[i])
    inv_mixing_1 = inv_mixing_1.inverse()

    for _ in range(100):
        target = chall.recvline(False)
        target = vector(F, Integer(target,16).digits(base=2, padto=8*dim))
        target = [m2 * target for m2 in inv_mixing_2]
        target = [inv_sboxes[i][tuple(x)] for i,x in enumerate(target)]
        target = vector(F, sum([list(x) for x in target],[]))
        target = inv_mixing_1 * target
        res = hex(int(ZZ(list(target), base=2)))[2:-2].zfill(2*dim-2)
        chall.recvuntil(b"> ")
        chall.sendline(res.encode())
else:
    print("sploit failed :(")
    exit()

print(chall.recvline().decode())
```
