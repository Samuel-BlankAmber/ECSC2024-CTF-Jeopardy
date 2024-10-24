#!/usr/bin/env python3

# A prepared Solution.exe is located in the health folder on the target machine. The solution is only accessible by the health user. The health user has the same privileges as the user provided for the participants.

import logging
import os

import requests
from requests_ntlm import HttpNtlmAuth

logging.disable()

CHECKER_USERNAME = os.environ.get("CHECKER_USERNAME", "health")
CHECKER_PASSWORD = os.environ.get("CHECKER_PASSWORD", "Passw0rd!")

URL = os.environ.get("URL", "http://jaws.challs.jeopardy.ecsc2024.it")
if URL.endswith("/"):
    URL = URL[:-1]

COMMAND_OUTPUT_START = '{"output":"'
COMMAND_OUTPUT_END = '\\r\\n"'

def main():
    r = requests.post(f"{URL}/command", json={"command": "./health/Solution.exe"}, auth=HttpNtlmAuth(CHECKER_USERNAME, CHECKER_PASSWORD))

    if not COMMAND_OUTPUT_START in r.text:
        print("Failed to run solution")
        print(r.text)
        exit(1)

    try:
        output = r.json()["output"]
    except:
        print("Failed to parse output")
        print(r.text)
        exit(1)

    output = output.split(COMMAND_OUTPUT_START)[1].split(COMMAND_OUTPUT_END)[0].rstrip()

    print(output)

if __name__ == '__main__':
    main()