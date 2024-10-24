#!/usr/bin/env python3

import logging
import os

import pwn

logging.disable()

# For TCP connection
HOST = os.environ.get("HOST", "ngc.challs.jeopardy.ecsc2024.it")
PORT = int(os.environ.get("PORT", 47018))

# Check challenge works properly
sol = open(os.path.join(os.path.dirname(__file__), 'sol.txt'), 'r').read()
r = pwn.remote(HOST, PORT)
r.recvline()
r.sendline(sol.encode())
print(r.recvline())
