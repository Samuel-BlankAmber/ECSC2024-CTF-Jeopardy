#!/usr/bin/env python3
from letters import *

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