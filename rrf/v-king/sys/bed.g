; bed.g
; called to perform automatic bed compensation via G32

M401

G30 P0 X175 Y50 Z-99999 ; H-0.02
G30 P1 X300 Y350 Z-99999 ; H+0.1
G30 P2 X50 Y350 Z-99999 S3 H-0.1

;G30 P0 X175 Y{10+global.zprobe_y} Z-99999
;G30 P1 X10 Y360 Z-99999
;G30 P2 X340 Y360 Z-99999 S3

;G30 P0 X10 Y{10+global.zprobe_y} Z-99999
;G30 P1 X340 Y{10+global.zprobe_y} Z-99999
;G30 P2 X340 Y360 Z-99999
;G30 P3 X10 Y360 Z-99999 S3

M402