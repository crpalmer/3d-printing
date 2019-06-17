; bed.g
; called to perform automatic bed compensation via G32

G1 Z2
G1 X170 Y10 F12000
G30 P0 Z-99999

G1 Z2
G1 Y380 F12000
G30 P1 S2 Z-99999

