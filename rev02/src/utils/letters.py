from colors import colors
import random
import string

color_names=list(colors.keys())

def random_color():
    color='Red' # Randomly selected
    return color

def draw_line(endy, endx, color):
    return bytes([83])+(color_names.index(color)+1).to_bytes(1, 'little')+endx.to_bytes(2, 'little')+endy.to_bytes(2, 'little')+b"\x00\x00"

def draw_circle(endy,endx,color,radius,simmetry,direction):
    symmetrydirectionbyte=0x00
    if(direction):
        symmetrydirectionbyte |= 0xF0
    if(simmetry):
        symmetrydirectionbyte |= 0x0F
    return bytes([75])+(color_names.index(color)+1).to_bytes(1, 'little')+endx.to_bytes(2, 'little')+endy.to_bytes(2, 'little')+radius.to_bytes(1, 'little')+bytes([symmetrydirectionbyte])

def number_0(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(50, x_offset+25, 'White')
    code+=draw_circle(50, x_offset, color, 13, 0,1)
    code+=draw_line(70, x_offset, color)
    code+=draw_circle(70, x_offset+25, color, 13, 0,1)
    code+=draw_line(50, x_offset+25, color)
    code+=draw_line(70, x_offset, color)
    return code

def number_1(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(90, x_offset+30, color)
    code+=draw_line(90, x_offset+15, color)
    code+=draw_line(30, x_offset+15, color)
    code+=draw_line(45, x_offset, color)
    return code

def number_2(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(90, x_offset+30, color)
    code+=draw_line(90, x_offset, color)
    code+=draw_line(60, x_offset+20, color)
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_circle(60, x_offset+20, color, 22, 1,0)
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_circle(40, x_offset, color, 17, 0,1)
    return code

def number_3(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+5, 'White')
    code+=draw_circle(45, x_offset+30, color, 20,1,0)
    code+=draw_circle(60, x_offset+5, color, 20,1,0)
    code+=draw_circle(75, x_offset+30, color, 20,1,0)
    code+=draw_circle(90, x_offset+5, color, 20,1,0)
    return code

def number_4(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(90, x_offset+15, 'White')
    code+=draw_line(30, x_offset+15, color)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(60, x_offset+27, color)
    return code

def number_5(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+30, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(55, x_offset, color)
    code+=draw_line(55, x_offset+15, color)
    code+=draw_circle(90, x_offset+15, color, 18,1,0)
    code+=draw_line(90, x_offset, color)
    code+=draw_line(90, x_offset+15, color)
    return code

def number_6(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(90, x_offset+15, 'White')
    code+=draw_circle(60, x_offset+15, color, 15,1,0)
    code+=draw_circle(90, x_offset+15, color, 16,1,0)
    code+=draw_line(65, x_offset, 'White')
    code+=draw_line(30, x_offset+30, color)
    return code

def number_7(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(30, x_offset, color)
    return code

def number_8(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_circle(45, x_offset+30, color, 20,1,0)
    code+=draw_circle(60, x_offset+15, color, 20,1,0)
    code+=draw_circle(75, x_offset+30, color, 20,1,0)
    code+=draw_circle(90, x_offset+15, color, 20,1,0)
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_circle(45, x_offset, color, 20,0,1)
    code+=draw_circle(60, x_offset+15, color, 20,0,1)
    code+=draw_circle(75, x_offset, color, 20,0,1)
    code+=draw_circle(90, x_offset+15, color, 20,0,1)
    return code

def number_9(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_circle(45, x_offset+30, color, 20,1,0)
    code+=draw_circle(60, x_offset+15, color, 20,1,0)
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_circle(45, x_offset, color, 20,0,1)
    code+=draw_circle(60, x_offset+15, color, 20,0,1)
    code+=draw_line(45, x_offset+32, 'White')
    code+=draw_line(90, x_offset, color)
    return code

def letter_a(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+15, color)
    code+=draw_line(90, x_offset+30, color)
    code+=draw_line(70, x_offset+30-5, color)
    code+=draw_line(70, x_offset+5, color)
    return code

def letter_b(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(30, x_offset+5, color)
    code+=draw_circle(45, x_offset+30, color, 20,1,0)
    code+=draw_circle(60, x_offset+5, color, 20,1,0)
    code+=draw_circle(75, x_offset+30, color, 20,1,0)
    code+=draw_circle(90, x_offset+5, color, 20,1,0)
    return code

def letter_c(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(50, x_offset+25, 'White')
    code+=draw_circle(50, x_offset, color, 13, 0,1)
    code+=draw_line(70, x_offset, color)
    code+=draw_circle(70, x_offset+25, color, 13, 0,1)
    return code

def letter_d(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(30, x_offset+5, color)
    code+=draw_circle(45, x_offset+30, color, 20,1,0)
    code+=draw_line(75, x_offset+30, color)
    code+=draw_circle(90, x_offset+5, color, 20,1,0)
    return code

def letter_e(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(30, x_offset, color)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(60, x_offset+20, color)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(90, x_offset, color)
    code+=draw_line(90, x_offset+30, color)
    code+=draw_line(90, x_offset, color)
    code+=draw_line(90, x_offset+30, color)
    return code

def letter_f(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(30, x_offset, color)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(60, x_offset+20, color)
    return code

def letter_g(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(50, x_offset+25, 'White')
    code+=draw_circle(50, x_offset, color, 13, 0,1)
    code+=draw_line(70, x_offset, color)
    code+=draw_circle(70, x_offset+25, color, 13, 0,1)
    code+=draw_line(60, x_offset+25, color)
    code+=draw_line(60, x_offset+15, color)
    return code

def letter_h(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(60, x_offset+30, color)
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(90, x_offset+30, color)
    return code

def letter_i(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(90, x_offset+15, 'White')
    code+=draw_line(30, x_offset+15, color)
    return code

def letter_j(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(75, x_offset+30, 'White')
    code+=draw_circle(90, x_offset+15, color, 20,1,0)
    code+=draw_line(75, x_offset, 'White')
    code+=draw_circle(90, x_offset+15, color, 20,0,1)
    code+=draw_line(75, x_offset+30, 'White')
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(30, x_offset+15, color)
    return code

def letter_k(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(90, x_offset+30, color)
    return code

def letter_l(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(90, x_offset, color)
    code+=draw_line(90, x_offset+30, color)
    return code

def letter_m(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(60, x_offset+15, color)
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(90, x_offset+30, color)
    return code

def letter_n(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(90, x_offset+30, color)
    code+=draw_line(30, x_offset+30, color)
    return code

def letter_o(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(50, x_offset+25, 'White')
    code+=draw_circle(50, x_offset, color, 13, 0,1)
    code+=draw_line(70, x_offset, color)
    code+=draw_circle(70, x_offset+25, color, 13, 0,1)
    code+=draw_line(50, x_offset+25, color)
    return code

def letter_p(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(30, x_offset+5, color)
    code+=draw_circle(45, x_offset+30, color, 20,1,0)
    code+=draw_circle(60, x_offset+5, color, 20,1,0)
    code+=draw_line(60, x_offset, color)
    return code

def letter_q(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(50, x_offset+25, 'White')
    code+=draw_circle(50, x_offset, color, 13, 0,1)
    code+=draw_line(70, x_offset, color)
    code+=draw_circle(70, x_offset+25, color, 13, 0,1)
    code+=draw_line(50, x_offset+25, color)
    code+=draw_line(70, x_offset+15, 'White')
    code+=draw_line(90, x_offset+30, color)
    return code

def letter_r(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(30, x_offset+5, color)
    code+=draw_circle(45, x_offset+30, color, 20,1,0)
    code+=draw_circle(60, x_offset+5, color, 20,1,0)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(90, x_offset+30, color)
    return code

def letter_s(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_circle(45, x_offset+30, 'White', 20,1,0)
    code+=draw_circle(60, x_offset+15, 'White', 20,1,0)
    code+=draw_circle(75, x_offset+30, color, 20,1,0)
    code+=draw_circle(90, x_offset+5, color, 20,1,0)
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_circle(45, x_offset, color, 20,0,1)
    code+=draw_circle(60, x_offset+15, color, 20,0,1)
    return code

def letter_t(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(90, x_offset+15, 'White')
    code+=draw_line(30, x_offset+15, color)
    code+=draw_line(30, x_offset, color)
    code+=draw_line(30, x_offset+30, color)
    return code

def letter_u(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(75, x_offset+30, 'White')
    code+=draw_circle(90, x_offset+15, color, 20,1,0)
    code+=draw_line(75, x_offset, 'White')
    code+=draw_circle(90, x_offset+15, color, 20,0,1)
    code+=draw_line(75, x_offset+30, 'White')
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(75, x_offset, 'White')
    code+=draw_line(30, x_offset, color)
    return code

def letter_v(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(90, x_offset+15, 'White')
    code+=draw_line(30, x_offset, color)
    code+=draw_line(90, x_offset+15, color)
    code+=draw_line(30, x_offset+30, color)
    return code

def letter_w(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, 'White')
    code+=draw_line(90, x_offset+7, color)
    code+=draw_line(30, x_offset+15, color)
    code+=draw_line(90, x_offset+22, color)
    code+=draw_line(30, x_offset+30, color)
    return code

def letter_x(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(30, x_offset, 'White')
    code+=draw_line(90, x_offset+30, color)
    return code

def letter_y(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(30, x_offset, 'White')
    code+=draw_line(60, x_offset+15, color)
    return code

def letter_z(x_offset):
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset, 'White')
    code+=draw_line(30, x_offset+30, color)
    code+=draw_line(90, x_offset, color)
    code+=draw_line(90, x_offset+30, color)
    return code

def open_bracket(x_offset):  # {
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_line(30, x_offset+10, color)
    code+=draw_line(55, x_offset+10, color)
    code+=draw_line(60, x_offset, color)
    code+=draw_line(65, x_offset+10, color)
    code+=draw_line(90, x_offset+10, color)
    code+=draw_line(90, x_offset+15, color)
    return code

def close_bracket(x_offset):  # }
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(30, x_offset+15, 'White')
    code+=draw_line(30, x_offset+20, color)
    code+=draw_line(55, x_offset+20, color)
    code+=draw_line(60, x_offset+30, color)
    code+=draw_line(65, x_offset+20, color)
    code+=draw_line(90, x_offset+20, color)
    code+=draw_line(90, x_offset+15, color)
    return code

def underscore(x_offset): # _
    code=b""
    color=random_color()
    code+=draw_line(90, x_offset, 'White')
    code+=draw_line(90, x_offset+30, color)
    return code

letters = string.ascii_uppercase  # 'A' to 'Z'
digits = '0123456789'

# Create a dictionary that maps each letter and digit to its corresponding function
function_map = {char: globals()[f'letter_{char.lower()}'] for char in letters}

for digit in digits:
    function_map[digit]=globals()[f'number_{digit}']

function_map["{"]=open_bracket
function_map["}"]=close_bracket
function_map["_"]=underscore