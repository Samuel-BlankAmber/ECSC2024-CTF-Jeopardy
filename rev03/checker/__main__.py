from pwn import *
import logging
import os

logging.disable()

HOST = os.environ.get("HOST", "battleship.challs.jeopardy.ecsc2024.it")
PORT = int(os.environ.get("PORT", 47016))
s = remote(HOST, PORT)

NUM_BOATS = 150
MAX_MISS = 26

# prepare my boats naively
for i in range(NUM_BOATS):
    s.sendlineafter(b"(x y): ", f"{i} {i}".encode())
#log.info(f"Boats placed")

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
#log.info(f"Total tries: {total_tries}")

collisions = total_tries - MAX_MISS
#log.info(f"Collisions: {collisions}")

rand_state = []

# send first MAX_MISS - 1 missiles and take computer hits
for i in range(MAX_MISS - 1):
    s.readuntil(b"Computer tries to hit ")
    x, y = map(int, s.readuntil(b")").strip().decode()[1:-1].split())
    rand_state.append(x)
    rand_state.append(y)

    # send missile naively
    s.sendlineafter(b"(x y): ", f"{i} {i}".encode())

#log.info(f"Random state: {rand_state}")


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

#log.info(f"Reverted random state: {rand_state}")

computer_boats = []
for i in range(NUM_BOATS + collisions):
    rand_state, x = forward_step(rand_state)
    rand_state, y = forward_step(rand_state)
    computer_boats.append((x, y))

#log.info(f"Computer boats: {computer_boats}")

# send missiles
for boat in computer_boats:
    s.sendlineafter(b"(x y): ", f"{boat[0]} {boat[1]}".encode())

# get flag
s.recvuntil(b"You win!\n")
flag = s.recvline().strip().decode()
#log.success(f"Flag: {flag}")
print(flag)
