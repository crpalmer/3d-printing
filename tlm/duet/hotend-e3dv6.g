; Heaters
M305 P1 T100000 B4725 C7.060000e-8 R4700  ; Set thermistor + ADC parameters for heater 1 (e3d)
M143 H2 S285                              ; Set temperature limit for heater 2 to 285C

; Tools
M563 P0 D0 H1 S"E3D v6"                   ; Define tool 0
G10 P0 X0 Y0 Z0                           ; Set tool 0 axis offsets
G10 P0 R0 S0                              ; Set initial tool 0 active and standby temperatures to 0C
