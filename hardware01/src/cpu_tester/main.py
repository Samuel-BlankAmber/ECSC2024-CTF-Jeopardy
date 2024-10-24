from machine import Pin, I2C, UART
from time import sleep
import rp2

rst = Pin(4, Pin.OPEN_DRAIN, value=1)
i2c = I2C(1, scl=Pin(3), sda=Pin(2), freq=100_000)
uart = UART(0, baudrate=115200, tx=Pin(0), rx=Pin(1), timeout=1000, rxbuf=4096)
led1 = Pin(10, Pin.OUT, value=0)
led2 = Pin(11, Pin.OUT, value=0)

BASE = 50
INCREMENT = 50


def reset(chall):
    rst.value(0)
    sleep(0.1)
    rst.value(1)
    while True:
        l = uart.readline()
        if l is not None:
            l = l.strip()
            print(l)
            if ">" in l:
                uart.write(chall)
                uart.write("\r\n")
                uart.readline()  # Read the feedback
                break


def i2c_test():
    reset("1")
    print(uart.readline())
    print(uart.readline())
    for i in range(1000):
        line = uart.readline()
        if line is None:
            continue
        # print(line)
        line = line.strip().decode()
        line = line.replace("0x", "")
        line = line.replace(" ", "")
        data = bytes.fromhex(line.strip())
        # print(data)
        i2c.writeto(0x42, data)
        l = uart.readline().decode()
        #print(l)
    assert "ECSC{f1rs7_st3p5_1nt0_th3_h4rdw4r3_c4t3g0ry}" in l


def pin_test():
    reset("2")
    print(uart.readline())
    print(uart.readline())
    uart.write("1".encode())
    sleep(0.1)
    uart.write("2".encode())
    sleep(0.1)
    uart.write("3".encode())
    sleep(0.1)
    uart.write("4".encode())
    sleep(0.1)
    uart.write("\n".encode())
    print(uart.readline())
    print(uart.readline())
    l = uart.readline().decode()
    print(l)
    assert "ECSC{1t_t4k3s_4_r3s3t}" in l


@rp2.asm_pio(set_init=rp2.PIO.OUT_LOW, out_shiftdir=rp2.PIO.SHIFT_RIGHT)
def programmable_cylinder():
    set(y, 3)
    set(pins, 1)[1]
    set(pins, 0)

    label("loop")

    pull()
    mov(x, osr)
    label("delay")
    jmp(x_dec, "delay")

    set(pins, 1)[1]
    set(pins, 0)

    jmp(y_dec, "loop")

    label("end")
    nop()
    jmp("end")


def run_programmable_cylinder(a, b, c):
    sleep(1)
    sm = rp2.StateMachine(0, programmable_cylinder, freq=120000, set_base=Pin(5))
    sm.put(a)
    sm.put(b)
    sm.put(c)
    sm.active(1)
    sleep(0.1)
    sm.active(0)


def find_index(cylinder, value):
    for i, v in enumerate(cylinder):
        if v == value:
            return i
    return -1


def find_greatest_common_indexes(cylinders):
    common_numbers = set(cylinders[0])
    for sublist in cylinders[1:]:
        common_numbers.intersection_update(sublist)
    if not common_numbers:
        return None, []
    greatest_common_number = max(common_numbers)
    indexes = []
    for sublist in cylinders:
        if greatest_common_number in sublist:
            indexes.append(sublist.index(greatest_common_number))
        else:
            indexes.append(None)
    return greatest_common_number, indexes


def read_cylinders():
    i = -1
    j = 0
    cylinders = [[], [], []]
    while True:
        l = uart.readline()
        if l is not None:
            l = l.strip()
            if "ROULETTE" in l:
                i = 0
                continue
            if i >= 0:
                cylinders[i].append(int(l))
                j += 1
                if j == 256:
                    i += 1
                    j = 0
                    if i == 3:
                        break
    return cylinders


def read_results(cylinders):
    print(uart.readline())
    r1 = uart.readline().strip()
    pos1 = find_index(cylinders[0], int(r1))
    r2 = uart.readline().strip()
    pos2 = find_index(cylinders[1], int(r2))
    r3 = uart.readline().strip()
    pos3 = find_index(cylinders[2], int(r3))
    print("Read cylinders", r1, "->", pos1, "|", r2, "->", pos2, "|", r3, "->", pos3)
    print(uart.readline())
    return (pos1, pos2, pos3)


def apply_linear_coefficients(a, b, x):
    t = round(a * x + b)
    if t < 0:
        return 0
    return t


adj = [0, 0, 0]


def adjust(expectation, reality, limit=3):
    for i in range(limit):
        if reality[i] > expectation[i]:
            adj[i] -= 5
            return False
        elif reality[i] < expectation[i]:
            adj[i] += 5
            return False
    return True


def slot_machine_test():
    coeffs = [(2.717184, -6.578125), (2.740916, -6.74076), (2.74837, -6.86531)]  # 100
    print("Coefficients", coeffs)
    i = 0
    reset("3")
    while True:
        cylinders = read_cylinders()
        n, idxs = find_greatest_common_indexes(cylinders)

        t1 = apply_linear_coefficients(coeffs[0][0], coeffs[0][1], idxs[0]) + adj[0]
        t2 = apply_linear_coefficients(coeffs[1][0], coeffs[1][1], idxs[1]) + adj[1]
        t3 = apply_linear_coefficients(coeffs[2][0], coeffs[2][1], idxs[2]) + adj[2]
        print("Greatest number", n, "with indices", idxs, "and timings", [t1, t2, t3])
        run_programmable_cylinder(t1, t2, t3)
        r = read_results(cylinders)
        eq = adjust(idxs, r)
        if eq:
            i += 1
            print("Jackpot N", i)
            if i == 3:
                break
        else:
            i = 0
            print("Adjustments", adj)
            print(uart.readline())
            reset("3")

    l = uart.readline().decode()
    print(l)
    assert "ECSC{y0u'r3_s0_f4s7}" in l


led1.on()
i2c_test()
pin_test()
led1.off()
led2.on()
slot_machine_test()
led2.on()
led1.on()
