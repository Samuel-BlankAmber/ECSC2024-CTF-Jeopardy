import struct
from colors import colors
from letters import *

startx=1
starty=1

#with open("./letter.t", "wb") as f:
#    f.write(letter_z(5))


with open("./house.t", "wb") as f:
    f.write(draw_line(90, 1, 'White'))
    f.write(draw_line(90, 100, 'Green'))
    f.write(draw_line(90, 30, 'Green'))
    f.write(draw_line(50, 30, 'Crimson'))
    f.write(draw_line(50, 60, 'Crimson'))
    f.write(draw_line(90, 60, 'Crimson'))
    f.write(draw_line(89, 60, 'Green'))
    f.write(draw_line(50, 60, 'Crimson'))
    f.write(draw_line(30, 45, 'Crimson'))
    f.write(draw_line(50, 30, 'Crimson'))
    f.write(draw_line(90, 30, 'Crimson'))
    f.write(draw_line(90, 40, 'Green'))
    f.write(draw_line(89, 40, 'Green'))
    f.write(draw_line(75, 40, 'Maroon'))
    f.write(draw_line(75, 50, 'Maroon'))
    f.write(draw_line(90, 50, 'Maroon'))

# with open("./circle.t", "wb") as f:
#     f.write(draw_line(50,50,'White'))
#     f.write(draw_circle(40,40,'Red',10,1,1))


# with open("./tree.t", "wb") as f:
#     f.write(draw_line(100,45,'White'))
#     f.write(draw_line(100,55,'Maroon'))
#     for x in range(1,50):
#         f.write(draw_line(100-x,55,'Maroon'))
#         f.write(draw_line(100-x,45,'Maroon'))
#         f.write(draw_line(99-x,45,'Maroon'))
#         f.write(draw_line(99-x,55,'Maroon'))