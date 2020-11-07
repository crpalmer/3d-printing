; bed.g
; called to perform automatic delta calibration via G32
;
; Probe the bed at 6 peripheral and 6 halfway points, and perform 6-factor auto compensation
; Points are 140mm and 70mm from center starting at a 30 degree angle to match the bed mounting

G30 P0 X70 Y121.25 H0 Z-99999
G30 P1 X140 Y0 H0 Z-99999
G30 P2 X70 Y-121.25 H0 Z-99999
G30 P3 X-70 Y-121.25 H0 Z-99999
G30 P4 X-140 Y0 H0 Z-99999
G30 P5 X-70 Y121.25 H0 Z-99999
G30 P6 X35 Y60.6 H0 Z-99999
G30 P7 X70 Y0 H0 Z-99999
G30 P8 X35 Y-60.6 H0 Z-99999
G30 P9 X-35 Y-60.6 H0 Z-99999
G30 P10 X-70 Y0 H0 Z-99999
G30 P11 X-35 Y60.6 H0 Z-99999
G30 P12 X0 Y0 H0 Z-99999 S6

; Use S-1 for measurements only, without calculations. Use S4 for endstop heights and Z-height only. Use S6 for full 6 factors
; If your Z probe has significantly different trigger heights depending on XY position, adjust the H parameters in the G30 commands accordingly. The value of each H parameter should be (trigger height at that XY position) - (trigger height at centre of bed)


