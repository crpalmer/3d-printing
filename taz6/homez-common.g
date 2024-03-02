M401

G91
G1 H2 Z5 F6000    ; lift Z relative to current position
G90

G1 X{150 - global.zprobe_offset_x} Y{150 - global.zprobe_offset_y} F12000
G30

M402