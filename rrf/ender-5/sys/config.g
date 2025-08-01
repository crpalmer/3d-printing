M550 P"ender-5"                                           ; Set our hostname
M552 S1 P0.0.0.0                                          ; Enable the ethernet connection with DHCP IP address assignment
M554 P192.168.1.1

M98 P"/sys/global-declarations.g"
M98 P"/sys/mqtt-enable.g"

; General preferences
G90                                                    ; send absolute coordinates...
M83                                                    ; ...but relative extruder moves

; Drives
M569 P0.0 S1 ; D3                                        ; z front: goes forward
M569 P0.1 S1 ; D3                                        ; e0: goes forwards
M569 P0.2 S0 ; D3                                        ; z back left: goes backward
M569 P0.3 S0 ; D3                                        ; u: goes backwards
M569 P0.4 S0 ; D3                                        ; z back right: goes backward
M569 P0.5 S1 ; D3                                        ; x: goes forward
M569 P1.0 S0 ; D3                                        ; y left: goes backward
M569 P1.1 S0 ; D3                                        ; e1: goes backward
M569 P1.2 S1 ; D3                                        ; y right: goes forward

M584 X0.5 Y1.0:1.2 u0.3 E0.1:1.1 Z0.0:0.2:0.4          ; set drive mapping (front, bl, br)

; Z "leadscrew" positions
M671 X110:30:195 Y30:195:195 S10

; The motor specifications say 0.067 degree / step.  Let's assume that is rounded and is really
; 0.0666... Give a degree/step we can say it takes (360/dps) steps to make a rotation, each
; rotation moves 40mm and we are doing x16 microstepping.  So, at 0.067 degree/step we get:
; 0.067 degree/step: 360/0.067/40*16 = 2,149.25
; But if we do: 360/.066666666666666666666666666666666666/40*16 = 2160
;
; Given that given enough repeating digits we get arbitrarily close to a round number,
; it sounds to me like that is the more likely value.  Use it.

M92 X160.00 Y160.00 U160.00 Z2160.00 E680:680          ; set steps per mm (recommended; 690 orbiter)
M350 X16 Y16 U16 Z16 E16 I1                            ; Configure microstepping with interpolation

M566 X300.00 Y300.00 U300.00 Z240.00 E300:300 P1       ; set maximum instantaneous speed changes (mm/min)
M203 X24000.00 Y24000.00 U24000.00 Z600.00 E7200:7200  ; set maximum speeds (mm/min)
M201 X3500.00 Y3500.00 U3500.00 Z500.00 E5000:5000     ; set accelerations (mm/s^2)
M906 X1350 Y1000 U1350 Z840 E850:850 I30               ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                                ; Set idle timeout

; Axis Limits
M208 X-49.2 Y-30 Z0 U0 S1                              ; set axis minima
M208 X225 Y220 Z325 U275 S0                            ; set axis maxima

; Endstops
M574 X1 S1 P"^0.io5.in"                                ; configure active-high endstop for low end on X
M574 Y2 S1 P"^1.io0.in+^1.io3.in"                      ; configure active-high endstop for high end on Y
M574 U2 S1 P"^0.io6.in"                                ; configure active-high endstop for high end on U

; Z-Probe
M558 K0 P8 C"!^0.io1.in" A7 S0.005 R1 H5 F400 T24000
G31  K0 X0 Y0 Z0 P100
M558 K1 P8 C"!^1.io2.in" A7 S0.005 R1 H5 F400 T24000
G31  K1 X0 Y0 Z0 P100

M557 X5:220 Y5:215 P5                                  ; define mesh grid
M376 H3

; Filament sensor (BTT SFS 2.0)
M591 D0 P7 C"0.io0.in" L3 R50:150 E22 S1
M591 D1 P7 C"1.io5.in" L3 R50:150 E22 S1

; Pressure advance
M572 D0 S0.05

; Fans (tool 0)
M950 F0 C"out4" Q250                                   ; create fan and set its frequency
M106 P0 S0 H-1 C"part-0"                               ; set fan value (off). Thermostatic control is turned off
M950 F1 C"out5" Q500                                   ; create fan and set its frequency
M106 P1 S1 T45 H1                                      ; set fan value (on). Thermostatic control is turned on

; Fans (tool 1)
M950 F2 C"1.out6" Q250                                 ; create fan and set its frequency
M106 P2 S0 H-1 C"part-1"                               ; set fan value (off). Thermostatic control is turned off
M950 F3 C"1.out7" Q500                                 ; create fan and set its frequency
M106 P3 S1 T45 H2                                      ; set fan value (on). Thermostatic control is turned on

; Fans (board cooling)
M950 F4 C"!1.out3+out3.tach" Q25000                    ; create fan and set its frequency
M106 P4 S1 H-1                                         ; set fan value (on).  Thermostatic control is turned off
M950 F5 C"!1.out4+out4.tach" Q25000                    ; create fan and set its frequency
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
M307 H1 R4.042 K0.586:0.400 D2.02 E1.35 S1.00 B0 V23.8 ; tuned (3.6.0) at 220, 5mm off the bed with part cooling fan
M563 P0 S"E3Dv6" D0 H1 F0                              ; define tool 0
G10 P0 X0 Y0 Z0                                        ; set tool 0 axis offsets

; tool 1: thermistor (e3d)
M308 S2 P"1.temp2" Y"thermistor" T100000 B4725 C7.06e-8  ; configure sensor
M950 H2 C"1.out2" T2                                   ; create nozzle heater output and map it to sensor 2

; tool 1: revo 40w
M307 H2 R4.042 K0.586:0.400 D2.02 E1.35 S1.00 B0 V23.8 ; tuned (3.6.0) at 220, 5mm off the bed with part cooling fan
M563 P1 S"E3Dv6" D1 H2 X3 F2                           ; define tool 1
;G10 P1 X0 U0.2 Y-0.45 Z0.125
G10 P1 X0 U1.35 Y-0.3 Z-0.05 ; Z0.125

; Set both tools to standby mode
M568 A1 P0 R0 S0
M568 A1 P1 R0 S0

; Miscellaneous
M912 P0 S0
T0

M98 P"/sys/global-defaults.g"
