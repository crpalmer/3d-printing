; bed.g
; called to perform automatic bed compensation via G32

G31 Z0

G28
G1 Z5

M98 P/sys/bed-3point.g
M98 P/sys/zprobe.g

G1 X160 Y180 F12000
G4 P500
G30
