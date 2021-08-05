; bed.g
; called to perform automatic bed compensation via G32

G1 Z5
G1 X0 Y175 F12000
G30 P0 X25 Y175 Z-99999

G1 Z5
G1 X300 Y175 F12000
G30 P1 X325 Y175 Z-99999 S2
G1 Z5