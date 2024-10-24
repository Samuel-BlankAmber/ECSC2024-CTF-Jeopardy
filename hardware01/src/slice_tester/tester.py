from machine import Pin
from time import sleep

pins = [
    Pin(0, Pin.OUT, value=0),
    Pin(1, Pin.OUT, value=0),
    Pin(2, Pin.OUT, value=0),
    Pin(3, Pin.OUT, value=0),
    Pin(4, Pin.OUT, value=0),
    Pin(5, Pin.OUT, value=0),
    Pin(6, Pin.OUT, value=0),
    Pin(7, Pin.OUT, value=0),
    Pin(8, Pin.OUT, value=0),
    Pin(9, Pin.OUT, value=0),
    Pin(10, Pin.OUT, value=0),
    Pin(11, Pin.OUT, value=0),
]

while True:
    for pin in pins:
        pin.value(1)
        sleep(0.1)
        pin.value(0)
        sleep(0.1)
