; Heaters
M307 H1 A465.9 C265.7 D4.2 V23.8 B0       ; pid autotune @ 205
M305 P1 T100000 B4725 C7.060000e-8 R4700  ; Set thermistor + ADC parameters for heater 1 (e3d)
; M305 P1 B4388
M143 H1 S285                              ; Set temperature limit for heater 2 to 285C

; Tools
M563 P0 D0 H1 S"E3D v6" F2                 ; Define tool 0 (E1)
G10 P0 X0 Y0 Z0                           ; Set tool 0 axis offsets
G10 P0 R0 S0                              ; Set initial tool 0 active and standby temperatures to 0C
