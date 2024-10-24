from machine import Pin, UART
from time import sleep
import sys

rst = Pin(4, Pin.OPEN_DRAIN, value=1)
uart = UART(0, baudrate=115200, tx=Pin(0), rx=Pin(1), timeout=1000, rxbuf=4096)


def reset(chall):
    rst.value(0)
    sleep(0.001)
    rst.value(1)
    while True:
        l = uart.readline()
        print(l)
        if l is not None:
            l = l.strip()
            if ">" in l:
                uart.write(str(chall))
                uart.write("\r\n")
                print(uart.readline())
                break


reset(2)
pin = "1"
while True:
    l = uart.readline()
    if l is not None:
        l = l.strip()
        if "Insert PIN:" in l:
            for c in pin + "\r\n":
                uart.write(c)
                sleep(0.001)
            for _ in range(len(c)):
                uart.readline()
            l = uart.readline()
            if l is None:
                sys.exit()
            l = l.strip()
            print(l)
            if "Wrong length" in l:
                pin += "1"
            else:
                print(pin, len(pin))
                break
            l = ""


pin = "1111"
reset(2)
pinlen = len(pin)
pin = 10 ** (pinlen - 1)
cnt = 0
while True:
    if cnt == 10:
        reset(2)
        cnt = 0
        print("pin = " + str(pin))
    print(uart.readline())
    print(uart.readline())
    for c in str(pin) + "\r\n":
        uart.write(c)
        sleep(0.001)
    for _ in range(len(c)):
        uart.readline()
    l = uart.readline()
    if l is None:
        sys.exit()
    l = l.strip()
    print(l)
    if "Wrong PIN" in l:
        pin += 1
        print(pin)
    else:
        print(pin)
        break
