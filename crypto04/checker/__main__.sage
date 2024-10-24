import logging
logging.disable()
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