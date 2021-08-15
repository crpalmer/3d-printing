;
; TODO
;

; -------------------------


; General preferences
G90                                                    ; send absolute coordinates...
M83                                                    ; ...but relative extruder moves

; Drives
M569 P0 S1 D3                                          ; physical drive 0 goes forwards, stealthchop
M569 P1 S0 D3                                          ; physical drive 1 goes backwards
M569 P2 S0 D3                                          ; physical drive 2 goes backwards
M569 P3 S0 D3                                          ; physical drive 3 goes backwards
M569 P4 S0 D3                                          ; physical drive 4 goes backwards
M569 P1.0 S0 D3                                        ; physical drive 1.0 goes backwards
M569 P1.1 S1 D3                                        ; physical drive 1.1 goes forwards
M569 P1.2 S1 D3                                        ; physical drive 1.2 goes forwards
M584 X0.2 Y0.1:1.2 u1.1 E0.0 Z0.3:0.4                  ; set drive mapping
M92 X160.00 Y160.00 U160.00 Z800.00 E830               ; set steps per mm (should be e415, tlm had e398.1,i though 404.5?)*2(0.9degree stepper)
M350 X16 Y16 U16 Z16 E16 I1                            ; set microstepping to 256 interpolation
M566 X600.00 Y600.00 U600.00 Z18.00 E1000.00           ; set maximum instantaneous speed changes (mm/min) (bondtech)
M203 X24000.00 Y24000.00 U24000.00 Z360.00 E3600.00    ; set maximum speeds (mm/min) (bondtech)
M201 X500.00 Y500.00 U500.00 Z100.00 E1000.00          ; set accelerations (mm/s^2) (bondtech)
M906 X700 Y700 U700 Z800 E700 I30                      ; set motor currents (mA) and motor idle factor in per cent (bondtech)
M84 S30                                                ; Set idle timeout

; Z drive
M671 X175:175 Y-35:385 S2  			                   ; motor order: front, back

; Axis Limits
M208 X10 Y0 Z0 U-50 S1                                 ; set axis minima
M208 X350 Y350 Z420 U290 S0                            ; set axis maxima

; Endstops
M574 X2 S1 P"^0.io5.in"                                ; configure active-high endstop for high end on X
M574 Y2 S1 P"^0.io6.in+^1.io0.in"                      ; configure active-high endstop for high end on Y
M574 U1 S1 P"^1.io2.in"                                ; configure active-high endstop for high end on U

; Z-Probe
M950 S0 C"io1.out"                                     ; servo pin definition
M558 P9 C"^io1.in" H5 F100 T2000
G31 X0 Y55 Z1.30 P25
;M557 X5:200 Y5:200 P7                                  ; define mesh grid

; Fans
M950 F0 C"out5" Q250                                   ; create fan 0 on pin fan0 and set its frequency
M106 P0 S0 H-1                                         ; set fan 0 value. Thermostatic control is turned off
M950 F1 C"out6" Q500                                   ; create fan 1 on pin fan1 and set its frequency
M106 P1 S1 T45 H1                                      ; set fan 1 value. Thermostatic control is turned on

; Bed Heater
M308 S0 P"temp0" Y"thermistor" T100000 B4092           ; configure sensor 0
M950 H0 C"out0" T0                                     ; create bed heater output and map it to sensor 0
M307 H0 R0.272 C349.6 D8.37 S1.00 V23.7
M140 H0                                                ; map heated bed to heater 0
M143 H0 S120                                           ; set temperature limit for heater 0 to 120C

; e3dv6
M308 S1 P"temp1" Y"thermistor" T100000 B4725 C7.06e-8  ; configure sensor 1
M950 H1 C"out1" T1                                     ; create nozzle heater output and map it to sensor 1
M307 H1 R2.845 C223.2 D5.79 S1.00 V24.1
M563 P0 S"E3Dv6" D0 H1 F0                              ; define tool 0

; Tool (common)
G10 P0 X0 Y0 Z0                                        ; set tool 0 axis offsets
G10 P0 R0 S0                                           ; set initial tool 0 active and standby temperatures to 0C

; MCU DOES NOT WORK ON THE DUET 3 MINI 5+, DON'T CONFIGURE:
; M912 P0 S-12.5                                       ; Calibrate MCU temperature

; Miscellaneous
T0                                                     ; select first tool
