# ECSC 2024 - Jeopardy

## [rev] printer (24 solves)

I created a printer for my printing needs.
Of course it only reads custom files as I don't want anyone else to use it...

`nc printer.challs.jeopardy.ecsc2024.it 47020`

Author: Alberto Carboneri <@Alberto247>

## Overview

The challenge is a binary compiled from Fortran accepting a .t file and providing a .ppm file as output.
It is implementing a simple turtle, allowing to draw lines and arcs in various colors.

The remote is asking for a base64-encoded .t file, passing it to the challenge, and then scanning the image for QR codes. If a QR code decoding to the string "WA33INAR7JDKUPNJ" is found the flag is then provided.

## Solution

By reversing the binary and the provided house.t example it is possible to understand the binary input to the program.
The house.t file, while viewed as hexadecimal, che be seen to be made up of multiple byte octects.
Each octect starts with \x53, which indicates to the program to draw a line.
It is then followed by one byte, which by reversing the binary can be understood to identify the color, 4 bytes indicating the end coordinates of the move, and two zero bytes.
The turtle starts at position (1,1) on the canvas.

## Exploit

We can write a script to interpret our moves and build a valid QR. Then submitting it to the remote provides us with the flag.

```python
colors = {
    "Red": 0xFF0000,
    "Green": 0x00FF00,
    "Blue": 0x0000FF,
    "Yellow": 0xFFFF00,
    "Cyan": 0x00FFFF,
    "Magenta": 0xFF00FF,
    "Orange": 0xFFA500,
    "Purple": 0x800080,
    "Pink": 0xFFC0CB,
    "Brown": 0xA52A2A,
    "Black": 0x000000,
    "White": 0xFFFFFF,
    "Grey": 0x808080,
    "Light Blue": 0xADD8E6,
    "Light Green": 0x90EE90,
    "Dark Red": 0x8B0000,
    "Dark Blue": 0x00008B,
    "Dark Green": 0x006400,
    "Violet": 0xEE82EE,
    "Gold": 0xFFD700,
    "Silver": 0xC0C0C0,
    "Lavender": 0xE6E6FA,
    "Beige": 0xF5F5DC,
    "Turquoise": 0x40E0D0,
    "Teal": 0x008080,
    "Indigo": 0x4B0082,
    "Maroon": 0x800000,
    "Olive": 0x808000,
    "Coral": 0xFF7F50,
    "Crimson": 0xDC143C,
    "Salmon": 0xFA8072,
    "Plum": 0xDDA0DD,
    "Periwinkle": 0xCCCCFF,
    "Mint": 0x98FF98,
    "Navy": 0x000080,
    "Chartreuse": 0x7FFF00,
    "Tomato": 0xFF6347,
    "Khaki": 0xF0E68C,
    "Lime": 0x00FF00,
    "Sky Blue": 0x87CEEB,
    "Peach": 0xFFDAB9
}

color_names=list(colors.keys())

def draw_line(endy, endx, color):
    return bytes([83])+(color_names.index(color)+1).to_bytes(1, 'little')+endx.to_bytes(2, 'little')+endy.to_bytes(2, 'little')+b"\x00\x00"

code=draw_line(10,10, 'White')
data="""R7B,R7W,R6B,D1B
,L1B,L5W,L1B,L2W,L1B,L2W,L1B,L1W,L1B,L5W,D1B
,R1B,R1W,R3B,R1W,R1B,R1W,R4B,R2W,R1B,R1W,R3B,R1W,D1B
,L1B,L1W,L3B,L1W,L1B,L1W,L1B,L1W,L2B,L2W,L1B,L1W,L3B,L1W,D1B
,R1B,R1W,R3B,R1W,R1B,R1W,R1B,R2W,R1B,R2W,R1B,R1W,R3B,R1W,D1B
,L1B,L5W,L1B,L2W,L3B,L2W,L1B,L5W,D1B
,R7B,R1W,R1B,R1W,R1B,R1W,R1B,R1W,R6B,D1B
,L8W,L1B,L1W,L3B,L7W,D1W
,R5B,R1W,R2B,R2W,R2B,R1W,R2B,R1W,R1B,R1W,R2B,D1W
,L2W,L1B,L2W,L2B,L1W,L1B,L3W,L1B,L2W,L1B,L2W,L2B,D1B
,R1W,R1B,R2W,R1B,R1W,R2B,R3W,R1B,R2W,R2B,R2W,R2B,D1B
,L1B,L2W,L2B,L3W,L4B,L1W,L1B,L3W,L1B,L2W,D1W
,R2W,R1B,R3W,R2B,R1W,R1B,R1W,R1B,R4W,R1B,R1W,R2B,D1W
,L1W,L1B,L2W,L1B,L1W,L1B,L1W,L4B,L8W,D1W
,R7B,R1W,R2B,R1W,R1B,R2W,R1B,R2W,R1B,R2W,D1B
,L4B,L2W,L6B,L2W,L1B,L5W,D1B
,R1B,R1W,R3B,R1W,R1B,R1W,R1B,R1W,R2B,R2W,R1B,R2W,R1B,R1W,R1B,D1W
,L3W,L2B,L3W,L5B,L1W,L1B,L1W,L3B,L1W,D1B
,R1B,R1W,R3B,R1W,R1B,R1W,R1B,R1W,R1B,R1W,R1B,R1W,R3B,R1W,R1B,R1W,D1B
,L1W,L1B,L1W,L1B,L1W,L2B,L2W,L1B,L1W,L2B,L1W,L1B,L5W,D1B
,R7B,R1W,R2B,R1W,R1B,R2W,R1B,R3W,R3B"""
data = data.replace("\n", "").replace(" ", "")
data = data.split(",")

posx=10
posy=10

for token in data:
    d, a, c = token[0], token[1], token[2]
    a = int(a)
    print(d,a,c)
    match d:
        case 'D':
            posy+=a
        case 'U':
            posy-=a
        case 'L':
            posx-=a
        case 'R':
            posx+=a
    color = "Black"
    if(c=='W'):
        color="White"
    print(posx, posy, color)
    code+=draw_line(posy, posx, color)

with open("./qr.t", "wb") as f:
    f.write(code)

import base64
print(base64.b64encode(code))

```

```python
#!/usr/bin/env python3

import logging
import os
from pwn import *

logging.disable()

HOST = os.environ.get("HOST", "printer.challs.jeopardy.ecsc2024.it")
PORT = int(os.environ.get("PORT", 47020))

r = remote(HOST, PORT)

r.recvuntil(b":")
r.sendline(b"UwwKAAoAAABTCxEACgAAAFMMGAAKAAAAUwseAAoAAABTCx4ACwAAAFMLHQALAAAAUwwYAAsAAABTCxcACwAAAFMMFQALAAAAUwsUAAsAAABTDBIACwAAAFMLEQALAAAAUwwQAAsAAABTCw8ACwAAAFMMCgALAAAAUwsKAAwAAABTCwsADAAAAFMMDAAMAAAAUwsPAAwAAABTDBAADAAAAFMLEQAMAAAAUwwSAAwAAABTCxYADAAAAFMMGAAMAAAAUwsZAAwAAABTDBoADAAAAFMLHQAMAAAAUwweAAwAAABTCx4ADQAAAFMLHQANAAAAUwwcAA0AAABTCxkADQAAAFMMGAANAAAAUwsXAA0AAABTDBYADQAAAFMLFQANAAAAUwwUAA0AAABTCxIADQAAAFMMEAANAAAAUwsPAA0AAABTDA4ADQAAAFMLCwANAAAAUwwKAA0AAABTCwoADgAAAFMLCwAOAAAAUwwMAA4AAABTCw8ADgAAAFMMEAAOAAAAUwsRAA4AAABTDBIADgAAAFMLEwAOAAAAUwwVAA4AAABTCxYADgAAAFMMGAAOAAAAUwsZAA4AAABTDBoADgAAAFMLHQAOAAAAUwweAA4AAABTCx4ADwAAAFMLHQAPAAAAUwwYAA8AAABTCxcADwAAAFMMFQAPAAAAUwsSAA8AAABTDBAADwAAAFMLDwAPAAAAUwwKAA8AAABTCwoAEAAAAFMLEQAQAAAAUwwSABAAAABTCxMAEAAAAFMMFAAQAAAAUwsVABAAAABTDBYAEAAAAFMLFwAQAAAAUwwYABAAAABTCx4AEAAAAFMLHgARAAAAUwwWABEAAABTCxUAEQAAAFMMFAARAAAAUwsRABEAAABTDAoAEQAAAFMMCgASAAAAUwsPABIAAABTDBAAEgAAAFMLEgASAAAAUwwUABIAAABTCxYAEgAAAFMMFwASAAAAUwsZABIAAABTDBoAEgAAAFMLGwASAAAAUwwcABIAAABTCx4AEgAAAFMMHgATAAAAUwwcABMAAABTCxsAEwAAAFMMGQATAAAAUwsXABMAAABTDBYAEwAAAFMLFQATAAAAUwwSABMAAABTCxEAEwAAAFMMDwATAAAAUwsOABMAAABTDAwAEwAAAFMLCgATAAAAUwsKABQAAABTDAsAFAAAAFMLDAAUAAAAUwwOABQAAABTCw8AFAAAAFMMEAAUAAAAUwsSABQAAABTDBUAFAAAAFMLFgAUAAAAUwwYABQAAABTCxoAFAAAAFMMHAAUAAAAUwseABQAAABTCx4AFQAAAFMLHQAVAAAAUwwbABUAAABTCxkAFQAAAFMMFgAVAAAAUwsSABUAAABTDBEAFQAAAFMLEAAVAAAAUwwNABUAAABTCwwAFQAAAFMMCgAVAAAAUwwKABYAAABTDAwAFgAAAFMLDQAWAAAAUwwQABYAAABTCxIAFgAAAFMMEwAWAAAAUwsUABYAAABTDBUAFgAAAFMLFgAWAAAAUwwaABYAAABTCxsAFgAAAFMMHAAWAAAAUwseABYAAABTDB4AFwAAAFMMHQAXAAAAUwscABcAAABTDBoAFwAAAFMLGQAXAAAAUwwYABcAAABTCxcAFwAAAFMMFgAXAAAAUwsSABcAAABTDAoAFwAAAFMMCgAYAAAAUwsRABgAAABTDBIAGAAAAFMLFAAYAAAAUwwVABgAAABTCxYAGAAAAFMMGAAYAAAAUwsZABgAAABTDBsAGAAAAFMLHAAYAAAAUwweABgAAABTCx4AGQAAAFMLGgAZAAAAUwwYABkAAABTCxIAGQAAAFMMEAAZAAAAUwsPABkAAABTDAoAGQAAAFMLCgAaAAAAUwsLABoAAABTDAwAGgAAAFMLDwAaAAAAUwwQABoAAABTCxEAGgAAAFMMEgAaAAAAUwsTABoAAABTDBQAGgAAAFMLFgAaAAAAUwwYABoAAABTCxkAGgAAAFMMGwAaAAAAUwscABoAAABTDB0AGgAAAFMLHgAaAAAAUwweABsAAABTDBsAGwAAAFMLGQAbAAAAUwwWABsAAABTCxEAGwAAAFMMEAAbAAAAUwsPABsAAABTDA4AGwAAAFMLCwAbAAAAUwwKABsAAABTCwoAHAAAAFMLCwAcAAAAUwwMABwAAABTCw8AHAAAAFMMEAAcAAAAUwsRABwAAABTDBIAHAAAAFMLEwAcAAAAUwwUABwAAABTCxUAHAAAAFMMFgAcAAAAUwsXABwAAABTDBgAHAAAAFMLGwAcAAAAUwwcABwAAABTCx0AHAAAAFMMHgAcAAAAUwseAB0AAABTDB0AHQAAAFMLHAAdAAAAUwwbAB0AAABTCxoAHQAAAFMMGQAdAAAAUwsXAB0AAABTDBUAHQAAAFMLFAAdAAAAUwwTAB0AAABTCxEAHQAAAFMMEAAdAAAAUwsPAB0AAABTDAoAHQAAAFMLCgAeAAAAUwsRAB4AAABTDBIAHgAAAFMLFAAeAAAAUwwVAB4AAABTCxYAHgAAAFMMGAAeAAAAUwsZAB4AAABTDBwAHgAAAFMLHwAeAAAA")
r.recvuntil(b"ECSC{")
flag = b"ECSC{"+r.recvline(False)

print(flag.decode())
```
