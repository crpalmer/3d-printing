var tool = state.currentTool
T0

G91
G1 H2 Z5 F6000    ; lift Z relative to current position
G90

M401
G1 X{112.5 - global.zprobe_x} Y{112.5 - global.zprobe_y} F24000
G30
M402

T{var.tool}