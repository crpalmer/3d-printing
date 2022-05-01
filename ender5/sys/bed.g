; bed.g
; called to perform automatic bed compensation via G32

T0

G1 Z5
G1 X{global.frontX-global.blTouchX} Y{global.frontY-global.blTouchY} F24000
G30 P0 X{global.frontX-2*global.blTouchX} Y{global.frontY-2*global.blTouchY} Z-99999

G1 Z5
G1 X{global.brX-global.blTouchX} Y{global.blrY-global.blTouchY} F24000
G30 P1 X{global.brX-2*global.blTouchX} Y{global.blrY-2*global.blTouchY} Z-99999

G1 Z5
G1 X{global.blX-global.blTouchX} Y{global.blrY-global.blTouchY} F24000
G30 P2 X{global.blX-2*global.blTouchX} Y{global.blrY-2*global.blTouchY} Z-99999 S3