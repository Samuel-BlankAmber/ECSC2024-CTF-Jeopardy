# ECSC 2024 - Jeopardy

## [rev] battleship (24 solves)

I like so much this game, but winning seems impossible... only holes in the water!

_The timeout on the remote is 30 seconds._

`nc battleship.challs.jeopardy.ecsc2024.it 47016`

Author: Andrea Raineri <@Rising>

## Overview

We need to play battleship game against the computer to win the game. The game is nearly impossible to win just by trying to hit randomly as the size of the grid is 1024x1024 with only 150 boats to be found and the player has only a limited number of misses.
We need to find a way to know the exact locations of computer boats to win the game.

## Solution

Reversing the executable we notice two main functions that are involved in the gneeration of both computer boat coordinates and computer missile coordinates.

- `sub_13C5`, performing an initialization of a global state at `dword_104120` (from now on we refer to this function as `initrand`)

```c
int sub_13C5()
{
  int i; // [rsp+8h] [rbp-8h]
  int fd; // [rsp+Ch] [rbp-4h]

  fd = open("/dev/urandom", 0);
  if ( fd == -1 )
  {
    perror("init failed");
    exit(1);
  }
  if ( read(fd, dword_104120, 0xC8uLL) != 200 )
  {
    perror("init failed");
    exit(1);
  }
  for ( i = 0; i <= 49; ++i )
    dword_104120[i] &= 0x1FFu;
  return close(fd);
}
```

- `sub_149B`, generating a new number (`v2`) from the global state pushing it to the end of the state (from now on we refer to this function as `rand`)

```c
__int64 sub_149B()
{
  int i; // [rsp+0h] [rbp-8h]
  unsigned int v2; // [rsp+4h] [rbp-4h]

  v2 = (((LOWORD(dword_104120[0]) + (_WORD)qword_10417C) * (_WORD)dword_4014 + 131) * (_WORD)dword_4018) & 0x1FF;
  for ( i = 0; i <= 48; ++i )
    dword_104120[i] = dword_104120[i + 1];
  dword_1041E4 = v2;
  return v2;
}
```

After calling `initrand` at the beginning of the program, before launching side threads to handle game, computer and player tasks, the computer calls the `rand` function to generate numbers to be used as boat coordinates and missile coordinates for its moves.

The `rand` function is implementeing the following PRNG:
$$ x_n = ((x_{n-50} + x_{n-27})\cdot 361 + 131)\cdot 293 \qquad (mod \; 512) $$

Knowing at least 50 numbers extracted from the generator we are thus able to recover the original state by inverting the formula. Knowing the original state, we can recompute the coordinates of all computer boats and win the game.

We notice that the number of misses available is large enough to allow us to miss 25 times in order to get computer moves to reconstruct the generator state.

## Exploit

```python
from pwn import *

s = process("./main")

NUM_BOATS = 150
MAX_MISS = 26

# prepare my boats naively
for i in range(NUM_BOATS):
    s.sendlineafter(b"(x y): ", f"{i} {i}".encode())
log.info(f"Boats placed")

M = 512
C1 = 361
C2 = 293
K1 = 50
K2 = 27

invC1 = pow(C1, -1, M)
invC2 = pow(C2, -1, M)

# get total tries available to know computer collisions
s.readuntil(b"You have ")
total_tries = int(s.readuntil(b" tries").strip().decode().split()[0])
log.info(f"Total tries: {total_tries}")

collisions = total_tries - MAX_MISS
log.info(f"Collisions: {collisions}")

rand_state = []

# send first MAX_MISS - 1 missiles and take computer hits
for i in range(MAX_MISS - 1):
    s.readuntil(b"Computer tries to hit ")
    x, y = map(int, s.readuntil(b")").strip().decode()[1:-1].split())
    rand_state.append(x)
    rand_state.append(y)

    # send missile naively
    s.sendlineafter(b"(x y): ", f"{i} {i}".encode())

log.info(f"Random state: {rand_state}")


# revert rand to initial state
def backward_step(x):
    n = x[50 - 1]
    n = (n * invC2) % M
    n = (n - 131) % M
    n = (n * invC1) % M
    n = (n - x[50 - 27 - 1]) % M

    # shift right and add to the start
    x = [n] + x[:-1]

    return x


def forward_step(x):
    n = x[50 - 50]
    n = (n + x[50 - 27]) % M
    n = (n * C1) % M
    n = (n + 131) % M
    n = (n * C2) % M

    # shift left and add to the end
    x = x[1:] + [n]

    return x, n


for i in range(MAX_MISS - 1 + NUM_BOATS):
    rand_state = backward_step(rand_state)  # y
    rand_state = backward_step(rand_state)  # x

log.info(f"Reverted random state: {rand_state}")

computer_boats = []
for i in range(NUM_BOATS + collisions):
    rand_state, x = forward_step(rand_state)
    rand_state, y = forward_step(rand_state)
    computer_boats.append((x, y))

log.info(f"Computer boats: {computer_boats}")

# send missiles
for boat in computer_boats:
    s.sendlineafter(b"(x y): ", f"{boat[0]} {boat[1]}".encode())

# get flag
s.recvuntil(b"You win!\n")
flag = s.recvline().strip().decode()
log.success(f"Flag: {flag}")
```
