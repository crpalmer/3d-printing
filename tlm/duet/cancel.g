; stop.g
; called when a print is cancelled after a pause.
G28
M84
M140 S0
G10 P0 S0 R0
G10 P1 S0 R0
T-1
M107