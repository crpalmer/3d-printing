; bed.g
; called to perform automatic bed compensation via G32

;G1 Z5
G1 X170 Y20 F24000
G30 P0 X171.5 Y67 Z-99999

G1 X25 Y315 F24000
G30 P1 X26.5 Y362 Z-99999

G1 X320 Y315 F24000
G30 P2 X321.5 Y362 Z-99999 S3