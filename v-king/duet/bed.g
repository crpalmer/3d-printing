; bed.g
; called to perform automatic bed compensation via G32

G1 Z5
G1 X0 Y360 F12000
G30 P0 X0 Y360 Z-99999
G30 P1 X310 Y360 Z-99999
G30 P2 X154 Y0   Z-99999 S3
G1 X160 Y180
G30 S-1
G1 Z5
