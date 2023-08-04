; bed.g
; called to perform automatic bed compensation via G32

G30 P0 X180 Y{10+global.blTouchY} Z-99999
G30 P1 X{global.blX} Y360 Z-99999
G30 P2 X{global.brX} Y360 Z-99999 S3