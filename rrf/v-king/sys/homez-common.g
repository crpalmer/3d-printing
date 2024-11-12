G91
G1 H2 Z5 F6000    ; lift Z relative to current position
G90
M401
G1 X{(global.brX - global.blX) / 2 + global.blX - global.zprobe_x} Y{(global.blrY - global.frontY) / 2 + global.frontY - global.zprobe_y} F24000
G30 X{(global.brX - global.blX) / 2 + global.blX} Y{(global.blrY - global.frontY) / 2 + global.frontY}
M402