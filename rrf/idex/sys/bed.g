; bed.g
; called to perform automatic bed compensation via G32

G1 Z5
G1 X{global.xCenter} Y5 F12000
G30 P0 X{global.xCenter} Y{global.probeOffsetY + 5} Z-99999

G1 Z5
G1 X{global.xCenter} Y295 F12000
G30 P1 X{global.xCenter} Y{global.probeOffsetY + 295} Z-99999 S2
G1 Z5