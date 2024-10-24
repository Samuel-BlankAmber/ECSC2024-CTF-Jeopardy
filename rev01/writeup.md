# ECSC 2024 - Jeopardy

## [rev] Old Gen Crackme (1 solve)

The world is constantly evolving, but some CTF challenges are stuck in the past.

_Note: this and the Next Gen Crackme challenge are not related._

_The timeout on the remote is 60 seconds._

`nc ogc.challs.jeopardy.ecsc2024.it 47017`

Author: Matteo Rossi <@mr96>

## Overview

The challenge implements a classic crackme: we are asked for a key that is verified against some conditions and, if they all match, we are returned the flag.

## Solution

All the interesting checks happen (using the names given by IDA Freeware) in `sub_37C8`: the `main` function simply reads the input, passes it to this function and checks the result.

The first checks are pretty straightforward: we are asked for a string with length 999, in which every character with an index that is 4 mod 5 (4, 9, 14, ...) is a dash. In other words, we want a dash-separated string, with 200 chunks of size 4, that is something like `AAAA-BBBB-CCCC-...`.

In a single chunk, each character should be either an uppercase letter or a digit (it can be a dash too because the condition is not checked, but it's not an issue).

Every chunk is then processed: it is converted to an integer using a base36 encoding, and then stored together with its negation considering it as a 24-bit integer (i.e., for every chunk, both the chunk converted to integer, that we call `i_chunk`, and `i_chunk ^ 0xffffff` are stored as a pair). Moreover, the challenge checks that all these chunks are different when converted to integers.

At this point, another sequence is generated through `sub_2799`. This function is implementing a linear sieve to retrieve all the prime numbers up to `1 << 24`, that are stored in a `vector`.

At this point the main loop begins: for every prime number `p` (up to `1 << 24`) different from 2 the following happens.

For every element in the list of pairs, the number and the positions of the elements in the pair that are divisible by `p` is stored. If there are 2 or more items in the list for which both elements of the pair are divisible by the same prime, the check fails, no matter what happens next. Otherwise, a 2-SAT graph is built.

If there is exactly one of these pairs, conditions of the form $(\neg x_i \vee \neg x_i)$ are added, while if there are none of them, the conditions added to the graph have the form $(\neg x_i \vee \neg x_j)$, for all $i \neq j$, where $i$ and $j$ are the positions of the respective chunks in the list, and they span over all pairs for which exactly one of the elements in the pair is divisible by `p`.

This set of conditions basically means that, for every prime `p`, there must be a way to choose one element from each pair so that at most one element in the final list is divisible by `p`, and that all these conditions should be simultaneously verified. The condition with $i=j$ (the first of the two cases) "forces" the choice for that pair.

The last check in the 2-SAT solver ensures that this is true for all the possible choices of the elements of each pair, meaning that, taking an element in two different pairs, there must never be a common prime between them.

The easiest way to make it true is to just sample prime numbers for the chunks and check that there are not already-used primes in their negation, as done in the code below.

### A small "ouch" moment

As you can read from the source code, the type for the 2-SAT conditions was defined as `#define cond_type tuple<bool, int, bool, int>`, while the conditions were added as `make_tuple(one[i][0], one[i][1] ^ 1, one[j][0], one[j][1] ^ 1)`. This swapped the order of the variables, generating a "weird" situation in which the 2-SAT graph is a lot smaller than expected, having only 16 nodes instead of the expected 200 ones. The solution still works but I know that it could generate some confusion. I'm very sorry for that, it was not intended and not noticed during the challenge writing nor during testing.

## Exploit

```python
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
```
