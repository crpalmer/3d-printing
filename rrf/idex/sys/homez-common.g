var tool = state.currentTool

T0

G91
G1 H2 Z5 F6000    ; lift Z relative to current position
G90

M401
G1 X{global.xCenter} Y{global.yMax / 2 - global.probeOffsetY} F12000
G4 P100
G30
M402

T{var.tool}