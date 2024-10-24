#!/usr/bin/env python3

import logging
import os
from exploit import exploit

logging.disable()

HOST = os.environ.get("HOST", "secretkeeper.challs.jeopardy.ecsc2024.it")
PORT = int(os.environ.get("PORT", 47014))

flag = exploit(HOST, PORT)
print(flag)
