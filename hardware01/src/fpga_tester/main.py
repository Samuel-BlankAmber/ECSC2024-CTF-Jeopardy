from machine import Pin
import time


rst = Pin(0, Pin.OUT, value=0)
clk = Pin(1, Pin.OUT, value=0)
i0 = Pin(2, Pin.OUT, value=0)
i1 = Pin(3, Pin.OUT, value=0)
i2 = Pin(4, Pin.OUT, value=0)
i3 = Pin(5, Pin.OUT, value=0)
o0 = Pin(6, Pin.OUT)
o1 = Pin(7, Pin.OUT)
o2 = Pin(8, Pin.OUT)
o3 = Pin(9, Pin.OUT)
led1 = Pin(10, Pin.OUT, value=0)
led2 = Pin(11, Pin.OUT, value=0)


def clock():
    clk.on()
    time.sleep(0.01)
    clk.off()
    time.sleep(0.01)


def go(ii0, ii1, ii2, ii3):
    i0.value(ii0)
    i1.value(ii1)
    i2.value(ii2)
    i3.value(ii3)
    clock()


def read():
    return o0.value(), o1.value(), o2.value(), o3.value()


def reset():
    rst.on()
    clock()
    rst.off()
    time.sleep(0.01)


map = [
    ((0, 1, 0, 0), (0, 0, 0, 1)),
    ((0, 0, 0, 1), (0, 0, 1, 0)),
    ((1, 1, 1, 1), (0, 0, 1, 1)),
    ((1, 0, 1, 0), (0, 1, 1, 0)),
    ((0, 1, 0, 0), (0, 1, 1, 1)),
    ((0, 0, 0, 0), (1, 0, 1, 1)),
    ((1, 0, 1, 1), (1, 1, 1, 0)),
    ((1, 1, 1, 1), (0, 1, 0, 1)),
    ((0, 0, 0, 1), (0, 1, 0, 0)),
    ((0, 0, 0, 0), (1, 1, 0, 0)),
    ((1, 1, 0, 1), (1, 1, 0, 1)),
    ((0, 0, 0, 0), (1, 0, 0, 0)),
    ((1, 1, 1, 1), (1, 0, 1, 0)),
    ((0, 1, 0, 0), (1, 0, 0, 1)),
    ((1, 1, 1, 1), (1, 1, 1, 1)),
]

"""
go(1, 0, 1, 0)
go(1, 1, 1, 0)
go(1, 1, 1, 1)
go(0, 1, 0, 0)
go(0, 0, 0, 0)
go(0, 0, 1, 0)
"""

reset()

for tran in map:
    go(*tran[0])
    print(read())
    assert read() == tran[1]

# Read one nibble ad compose the flag
led1.on()
flag = ""
upper_nibble = None
clock()
while True:
    clock()
    nibble = read()
    print(nibble)
    if upper_nibble is None:
        upper_nibble = nibble
    else:
        flag += chr(
            int(
                f"{upper_nibble[0]}{upper_nibble[1]}{upper_nibble[2]}{upper_nibble[3]}{nibble[0]}{nibble[1]}{nibble[2]}{nibble[3]}",
                2,
            )
        )
        upper_nibble = None
        print(flag.encode())
        if "ECSC{3xpl0r3_th3_gr4ph}" in flag:
            led2.on()
            break

print(flag)
led2.on()
