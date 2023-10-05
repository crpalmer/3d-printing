; bed.g
; called to perform automatic bed compensation via G32

M401
G30 P0 X175 Y125 Z-99999
G30 P1 X100 Y250 Z-99999
G30 P2 X250 Y250 Z-99999 S3
M402