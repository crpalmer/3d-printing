;
; TODO
;

; -------------------------

global xMax = 340
global uMin = -57.7
global uMax = 283
global xCenter = 140

global e3dV6 = 1
global e3dVolcano = 2

global tool1 = global.e3dV6

; General preferences
G90                                                    ; send absolute coordinates...
M83                                                    ; ...but relative extruder moves

; Drives
M569 P0 S1 D3                                          ; physical drive 0 goes forwards, stealthchop
M569 P1 S0 D3                                          ; physical drive 1 goes backwards
M569 P2 S0 D3                                          ; physical drive 2 goes backwards
M569 P3 S0 D3                                          ; physical drive 3 goes backwards
M569 P4 S0 D3                                          ; physical drive 4 goes backwards
M569 P1.0 S1 D3                                        ; physical drive 1.0 goes forwards
M569 P1.1 S1 D3                                        ; physical drive 1.1 goes forwards
M569 P1.2 S1 D3                                        ; physical drive 1.2 goes forwards
M584 X0.2 Y0.1:1.2 u1.1 E0.0:1.0 Z0.3:0.4              ; set drive mapping
M92 X160.00 Y160.00 U160.00 Z800.00 E830:2700         ; set steps per mm (should be e415, tlm had e398.1,i though 404.5?)*2(0.9degree stepper)
M350 X16 Y16 U16 Z16 E16 I1                            ; set microstepping to 256 interpolation
M566 X600.00 Y600.00 U600.00 Z18.00 E1000:40             ; set maximum instantaneous speed changes (mm/min) (nimble v3)
M203 X24000.00 Y24000.00 U24000.00 Z360.00 E3600:3600  ; set maximum speeds (mm/min)
M201 X1000.00 Y1000.00 U1000.00 Z100.00 E1000:120       ; set accelerations (mm/s^2) (nimble v3)
M906 X1200 Y1000 U1200 Z1200 E500 I30                  ; set motor currents (mA) and motor idle factor in per cent (nimble v3	)
M84 S30                                                ; Set idle timeout

; Z drive
;M671 X{global.xCenter, global.xCenter} Y-35:385 S2  			                   ; motor order: front, back
M671 X140:140 Y-35:385 S2  			                   ; motor order: front, back

; Axis Limits
M208 X0 Y0 Z0 U{global.uMin} S1                        ; set axis minima
M208 X{global.xMax} Y350 Z420 U{global.uMax} S0        ; set axis maxima

; Endstops
M574 X2 S1 P"^0.io5.in"                                ; configure active-high endstop for high end on X
M574 Y2 S1 P"^0.io6.in+^1.io0.in"                      ; configure active-high endstop for high end on Y
M574 U1 S1 P"^1.io2.in"                                ; configure active-high endstop for high end on U

; Z-Probe
M950 S0 C"io1.out"                                     ; servo pin definition
M558 P9 C"^io1.in" H5 F100 T2000
G31 X0 Y55 Z1.4 P25
M557 X5:285 Y60:345 P7                                  ; define mesh grid
M376 H3

; Fans (tool 0)
M950 F0 C"out5" Q250                                   ; create fan and set its frequency
M106 P0 S0 H-1                                         ; set fan value (off). Thermostatic control is turned off
M950 F1 C"out6" Q500                                   ; create fan and set its frequency
M106 P1 S1 T45 H1                                      ; set fan value (on). Thermostatic control is turned on

; Fans (tool 1)
M950 F2 C"1.out7" Q250                                 ; create fan and set its frequency
M106 P2 S0 H-1                                         ; set fan value (off). Thermostatic control is turned off
M950 F3 C"1.out6" Q500                                 ; create fan and set its frequency
M106 P3 S1 T45 H2                                      ; set fan value (on). Thermostatic control is turned on

; Bed Heater
M308 S0 P"temp0" Y"thermistor" T100000 B4092           ; configure sensor
M950 H0 C"out0" T0                                     ; create bed heater output and map it to sensor 0
M307 H0 R0.272 C349.6 D8.37 S1.00 V23.7
M140 H0                                                ; map heated bed to heater 0
M143 H0 S120                                           ; set temperature limit for heater 0 to 120C

; tool 0: thermistor (e3d)
M308 S1 P"temp1" Y"thermistor" T100000 B4725 C7.06e-8  ; configure sensor
M950 H1 C"out1" T1                                     ; create nozzle heater output and map it to sensor 1

; tool 0: e3dv6 40w
M307 H1 B0 R2.593 C211.1:173.4 D5.20 S1.00 V24.1       ; tuned (new) at 255 10mm off the bed with the part cooling fan
M563 P0 S"E3Dv6" D0 H1 F0                              ; define tool 0
G10 P0 X0 Y0 Z0                                        ; set tool 0 axis offsets

; tool 1: thermistor (e3d)
M308 S2 P"1.temp2" Y"thermistor" T100000 B4725 C7.06e-8  ; configure sensor
M950 H2 C"1.out2" T2                                   ; create nozzle heater output and map it to sensor 2

if global.tool1 == global.e3dV6
  ; tool 1: e3dv6 40w
  M307 H2 B0 R2.508 C225.2 D5.67 S1.00 V24.1           ; tuned 255 10mm off of the bed with the part cooling fan
  M563 P1 S"E3Dv6" D1 H2 X3 F2                         ; define tool 1
  G10 P1 X0 Y0.3 Z-0.15                                ; set tool 1 axis offsets
elif global.tool1 == global.e3dVolcano
  ; tool 1: e3dv6 volcano 30w
  M307 H2 B0 R1.666 C251.2 D4.48 S1.00 V24.3           ; tuned 255 no part cooling fan
  M563 P1 S"volcano" D1 H2 X3 F2                       ; define tool 1
  G10 P1 X0 Y0 Z-9.45                                  ; set tool 1 axis offsets
else
  abort "Invalid tool for tool1"
endif

; Tool 2: duplicating mode

M563 P2 D0:1 H1:2 X0:3 F0:2                            ; tool 2 uses both extruders and hot end heaters, maps X to both X and U, and uses both print cooling fans
G10 P2 X-70 Y0 U110                                    ; set tool offsets and temperatures for tool 2
M567 P2 E1:1                                           ; set mix ratio 100% on both extruders
M568 P2 S1                                             ; turn on mixing for tool 2

; Tool (common)
G10 P0 R0 S0                                           ; set initial tool 0 active and standby temperatures to 0C
G10 P1 R0 S0                                           ; set initial tool 1 active and standby temperatures to 0C
G10 P2 R0 S0                                           ; set initial tool 2 active and standby temperatures to 0C

; MCU DOES NOT WORK ON THE DUET 3 MINI 5+, DON'T CONFIGURE:
; M912 P0 S-12.5                                       ; Calibrate MCU temperature

; Miscellaneous
