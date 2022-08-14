;
; TODO
;

; -------------------------

global includeDuplication = 0

global xMin = -49.2
global xMax = 225
global uMin = 0
global uMax = 275
global yMin = -30
global yMax = 220
global zMax = 325
global xCenter = 112.5
global yCenter = 110
global blTouchX = -2
global blTouchY = 47

global frontX = 110
global frontY = 30
global blX = 30
global brX = 195
global blrY = 200
 
global lastPurge0 = 0
global lastPurge1 = 0

; Variables to be used to work around PrusaSlicer "quirks"
global T0firstUse = true
global T1firstUse = true

; General preferences
G90                                                    ; send absolute coordinates...
M83                                                    ; ...but relative extruder moves

; Drives
M569 P0.0 S1 D3                                        ; z front: goes forward
M569 P0.1 S1 D3                                        ; e0: goes forwards
M569 P0.2 S0 D3                                        ; z back left: goes backward
M569 P0.3 S0 D3                                        ; u: goes backwards
M569 P0.4 S0 D3                                        ; z back right: goes backward
M569 P0.5 S1 D3                                        ; x: goes forward
M569 P1.0 S0 D3                                        ; y left: goes backward
M569 P1.1 S0 D3                                        ; e1: goes backward
M569 P1.2 S1 D3                                        ; y right: goes forward

M584 X0.5 Y1.0:1.2 u0.3 E0.1:1.1 Z0.0:0.2:0.4          ; set drive mapping (front, bl, br)

; Z "leadscrew" positions
;M671 X{global.frontX}:{global.blX}:{global.brX} Y{global.frontY}:{global.blrY}:{global.blrY} S10
M671 X110:30:195 Y30:195:195 S10

M92 X160.00 Y160.00 U160.00 Z2148.00 E680:680          ; set steps per mm (recommended; 690 orbiter)
M350 X16 Y16 U16 Z16 E16 I1                            ; set microstepping to 256 interpolation
M566 X600.00 Y600.00 U600.00 Z18.00 E300:300           ; set maximum instantaneous speed changes (mm/min)
M203 X24000.00 Y24000.00 U24000.00 Z600.00 E7200:7200  ; set maximum speeds (mm/min)
M201 X1000.00 Y1000.00 U1000.00 Z500.00 E800:800       ; set accelerations (mm/s^2)
M906 X1350 Y1000 U1350 Z840 I30
M906 E1200:1200 I10                                    ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                                ; Set idle timeout

; Axis Limits
M208 X{global.xMin} Y{global.yMin} Z0 U{global.uMin} S1                        ; set axis minima
M208 X{global.xMax} Y{global.yMax} Z{global.zMax} U{global.uMax} S0        ; set axis maxima

; Endstops
M574 X1 S1 P"^0.io5.in"                                ; configure active-high endstop for low end on X
M574 Y2 S1 P"^1.io0.in+^1.io3.in"                      ; configure active-high endstop for high end on Y
M574 U2 S1 P"^0.io6.in"                                ; configure active-high endstop for high end on U

; Z-Probe
M950 S0 C"io1.out"                                     ; servo pin definition
M558 P9 C"^io1.in" H5 F100 T2000
G31 X{-global.blTouchX} Y{-global.blTouchY} Z2.235 P25
M557 X10:215 Y10:150 P7                                ; define mesh grid
M376 H3

; Fans (tool 0)
M950 F0 C"out6" Q250                                   ; create fan and set its frequency
M106 P0 S0 H-1 C"part-0"                               ; set fan value (off). Thermostatic control is turned off
M950 F1 C"out5" Q500                                   ; create fan and set its frequency
M106 P1 S1 T45 H1                                      ; set fan value (on). Thermostatic control is turned on

; Fans (tool 1)
M950 F2 C"1.out6" Q250                                 ; create fan and set its frequency
M106 P2 S0 H-1 C"part-1"                               ; set fan value (off). Thermostatic control is turned off
M950 F3 C"1.out7" Q500                                 ; create fan and set its frequency
M106 P3 S1 T45 H2                                      ; set fan value (on). Thermostatic control is turned on

; Fans (board cooling)
M950 F4 C"!1.out3" Q25000                              ; create fan and set its frequency
M106 P4 S1 H-1                                         ; set fan value (on).  Thermostatic control is turned off
M950 F5 C"!1.out4" Q25000                              ; create fan and set its frequency
M106 P5 S1 H-1                                         ; set fan value (on).  Thermostatic control is turned off

; Bed Heater
M308 S0 P"temp0" Y"thermistor" T100000 B4092           ; configure sensor
M950 H0 C"out0" T0                                     ; create bed heater output and map it to sensor 0
M307 H0 R0.272 C349.6 D8.37 S1.00 V23.7
M140 H0                                                ; map heated bed to heater 0
M143 H0 S120                                           ; set temperature limit for heater 0 to 120C

; tool 0: thermistor (e3d)
M308 S1 P"temp1" Y"thermistor" T100000 B4725 C7.06e-8  ; configure sensor
M950 H1 C"out1" T1                                     ; create nozzle heater output and map it to sensor 1

; tool 0: revo 40w
M307 H1 B0 R2.593 C211.1:173.4 D5.20 S1.00 V24.1       ; tuned (new) at 255 10mm off the bed with the part cooling fan
M563 P0 S"E3Dv6" D0 H1 F0                              ; define tool 0
G10 P0 X0 Y0 Z0                                        ; set tool 0 axis offsets

; tool 1: thermistor (e3d)
M308 S2 P"1.temp2" Y"thermistor" T100000 B4725 C7.06e-8  ; configure sensor
M950 H2 C"1.out2" T2                                   ; create nozzle heater output and map it to sensor 2

; tool 1: revo 40w
M307 H2 B0 R2.593 C211.1:173.4 D5.20 S1.00 V24.1       ; tuned (new) at 255 10mm off the bed with the part cooling fan
M563 P1 S"E3Dv6" D1 H2 X3 F2                           ; define tool 1
G10 P1 X0 Y-0.5 Z0.05                                   ; set tool 1 axis offsets

; Set both tools to standby mode
M568 A1 P0 R0 S0
M568 A1 P1 R0 S0

; Tool 2: duplicating mode
if global.includeDuplication > 0
  M563 P2 D0:1 H1:2 X0:3 F0:2                            ; tool 2 uses both extruders and hot end heaters, maps X to both X and U, and uses both print cooling fans
  G10 P2 X-70 Y0 U110                                    ; set tool offsets and temperatures for tool 2
  M567 P2 E1:1                                           ; set mix ratio 100% on both extruders
  M568 P2 R0 S0                                          ; temperatures set to 0

; Miscellaneous
M912 P0 S0
T0