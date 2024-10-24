#!/usr/bin/env python3
from tempfile import NamedTemporaryFile
from base64 import b64decode
from yap import load, InvalidYamlError
from os import environ
from os.path import realpath
from json import dumps
from re import match


def menu():
    print("1. Write file")
    print("2. Load yaml from file")
    print("3. Print loaded yaml")


def validate_filename(val: str):
    val = realpath(val)
    if not match("^/tmp/[a-z0-9A-Z_]+$", val):
        raise ValueError(f"Path is not valid! '{val}'")
    return val


def main():
    values = {}
    dbg = environ.get("DEBUG", False) == "True"

    while True:
        if len(values.keys()) > 10:
            print("Stop allocating random stuff and solve the chall ty")
            break
        menu()
        choice = input("> ").strip()
        if choice == "1":
            print("Send me b64 of input on one line")
            data = b64decode(input("? ").encode())
            with NamedTemporaryFile(delete=False) as outfile:
                outfile.write(data)
                print(f"File is saved in {outfile.name}")
        elif choice == "2":
            fname = validate_filename(input("File name? ").strip())
            try:
                values[fname] = load(fname, debug=dbg)
            except InvalidYamlError as exc:
                print(f"Parsing failed, sry: '{exc}'")
        elif choice == "3":
            fname = input("File name? ").strip()
            if fname not in values.keys():
                print("No key found")
                continue
            print(dumps(values[fname], indent=4))
        else:
            print("Bro wtf")


if __name__ == '__main__':
    main()
