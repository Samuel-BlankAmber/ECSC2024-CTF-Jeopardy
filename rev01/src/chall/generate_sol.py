import gmpy2
import random
from math import gcd
from pyecm import factors

def tob(n):
    alph = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-"
    res = ""
    for i in range(4):
        res += alph[n%36]
        n //=36
    return res

p = 1
small_primes = []
key = []
used = []
while p < 2**20:
    p = gmpy2.next_prime(p)
    small_primes.append(p)

while len(key) < 200:
    p = random.choice(small_primes)
    tmp = list(set(list(factors(p^0xffffff, False, False, 7.97308847044, 1.0))))[1:]
    if all([x not in used for x in tmp]) and p not in tmp:
        used.append(p)
        used += tmp
        if p in small_primes:
            small_primes.remove(p)
        for coso in tmp:
            if coso in small_primes:
                small_primes.remove(coso)
        key.append(p)
print("-".join([tob(x) for x in key]))
