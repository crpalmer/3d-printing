; bed.g
; called to perform automatic bed compensation via G32

G1 Z5
G1 X175 Y0 F12000
G30 P0 X175 Y55 Z-99999

G1 Z5
G1 X175 Y295 F12000
G30 P1 X175 Y350 Z-99999 S2
G1 Z5