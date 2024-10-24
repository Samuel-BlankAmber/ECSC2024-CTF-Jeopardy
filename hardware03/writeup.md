# ECSC 2024 - Jeopardy

## [hardware] Secure PIN (19 solves)

Look at my new PIN protected flag, you cannot guess it!

Author: Giovanni Minotti <@Giotino>

## Overview

The challenge asks you for a PIN to get the flag. It checks first for its length and then for its value, giving different feedbacks.  
If the PIN is correct, the flag is printed; otherwise, you are asked to try again, and the program exits after 10 failed attempts.

## Solution

First bruteforce the length of the PIN, then bruteforce the PIN itself, resetting the board after 10 failed attempts.

## Exploit

[exploit.py](writeup/pin.py)
