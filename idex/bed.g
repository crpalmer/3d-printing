; bed.g
; called to perform automatic bed compensation via G32

G1 Z5
G1 X{global.xCenter} Y0 F12000
G30 P0 X{global.xCenter} Y55 Z-99999

G1 Z5
G1 X{global.xCenter} Y295 F12000
G30 P1 X{global.xCenter} Y350 Z-99999 S2
G1 Z5