from machine import Pin, I2C, UART

i2c = I2C(0, scl=Pin(1), sda=Pin(0), freq=100_000)
rst = Pin(7, Pin.OUT, value=1)
uart = UART(1, baudrate=115200, tx=Pin(8), rx=Pin(9), timeout=1000, rxbuf=4096)


def reset():
    rst.value(0)
    rst.value(1)
    while True:
        l = uart.readline()
        if l is not None:
            l = l.strip()
            print(l)
            if ">" in l:
                uart.write("1\r\n")
                uart.readline()
                break

reset()
print(uart.readline())
print(uart.readline())
while True:
    line = uart.readline()
    if line is None:
        continue
    print(line)
    line = line.strip().decode()
    line = line.replace('0x', '')
    line = line.replace(' ', '')
    data = bytes.fromhex(line.strip())
    print(data)
    i2c.writeto(0x42, data)
    print(uart.readline())
