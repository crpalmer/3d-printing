M561                                            ; clear any bed transform, otherwise homing may be at the wrong height
G28

G30 P0 X0.00 Y120.00 Z-99999 H0
G30 P1 X103.92 Y60.00 Z-99999 H0
G30 P2 X103.92 Y-60.00 Z-99999 H0
G30 P3 X0.00 Y-120.00 Z-99999 H0
G30 P4 X-103.92 Y-60.00 Z-99999 H0
G30 P5 X-103.92 Y60.00 Z-99999 H0
G30 P6 X0.00 Y60.00 Z-99999 H0
G30 P7 X51.96 Y-30.00 Z-99999 H0
G30 P8 X-51.96 Y-30.00 Z-99999 H0
G30 P9 X0 Y0 Z-99999 S6

G1 X0 Y0 Z150 F12000                    ; get the head out of the way of the bed

