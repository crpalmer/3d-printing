; bed.g
; called to perform automatic bed compensation via G32

G1 Z2
; G1 X162.5 Y190 F12000 ; Zero at the center of the bed
G1 X185 Y5 F12000  ; Zero at the front probe point
G30

; Probe it
M98 P/sys/bed-3point.g

; The G32 calibration seems to calibrate to something other than the right offset.  Either G30, G28 Z to try to fix it or manually adjust it
; G28 Z
;G1 Z5
;G92 Z5.065
;G1 Z5
;G30