G90
G1 X-20 Y255 F6000      ; move to the endstop
G91
G1 H1 Z-275 F1800       ; move Z down until the endstop is triggered
G90
G92 Z-1.1               ; set initial z zero
G1 H2 Z5 F100           ; lift Z to be clear of the endstop
M98 P"/sys/wipe.g"
G1 X-7 Y-15 Z3 F6000
G30