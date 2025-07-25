M550 P"idex"                                              ; Set our hostname
M552 S1 P0.0.0.0                                          ; Enable the ethernet connection with DHCP IP address assignment
M554 P192.168.1.1

M98 P"/sys/global-declarations.g"
M98 P"/sys/mqtt-enable.g"

; General preferences
G90                                                    ; send absolute coordinates...
M83                                                    ; ...but relative extruder moves

; Drives
M569 P0 S0 ; D3                                        ; physical drive 0 goes backwards, stealthchop
M569 P1 S0 ; D3                                        ; physical drive 1 goes backwards
M569 P2 S0 ; D3                                        ; physical drive 2 goes backwards
M569 P3 S0 ; D3                                        ; physical drive 3 goes backwards
M569 P4 S0 ; D3                                        ; physical drive 4 goes backwards
M569 P1.0 S1 ; D3                                      ; physical drive 1.0 goes forwards
M569 P1.1 S1 ; D3                                      ; physical drive 1.1 goes forwards
M569 P1.2 S1 ; D3                                      ; physical drive 1.2 goes forwards
M584 X0.2 Y0.1:1.2 u1.1 E0.0:1.0 Z0.3:0.4              ; set drive mapping
M92 X160.00 Y160.00 U160.00 Z800.00 E680:680           ; set steps per mm (recommended; 690 orbiter)
M350 X16 Y16 U16 Z16 E16 I1                            ; set microstepping to 256 interpolation
M566 X300.00 Y300.00 U300.00 Z240.00 E300:300 P1       ; set maximum instantaneous speed changes (mm/min)
M203 X24000.00 Y24000.00 U24000.00 Z600.00 E7200:7200  ; set maximum speeds (mm/min)
M201 X2500.00 Y2500.00 U2500.00 Z500.00 E5000:5000     ; set accelerations (mm/s^2)
M906 X1200 Y1000 U1200 Z840 E850:850 I30               ; Set motor currents (mA) and motor idle factor in per cent
M84 S30                                                ; Set idle timeout

; Z drive
;M671 X{global.xCenter, global.xCenter} Y-35:385 S2  			                   ; motor order: front, back
M671 X150:150 Y-35:385 S2  			                   ; motor order: front, back

; Axis Limits
M208 X0 Y-10 Z-5 U-50 S1                       ; set axis minima
M208 X350 Y356 Z425 U305 S0                            ; set axis maxima

; Endstops
M574 X2 S1 P"^0.io5.in"                                ; configure active-high endstop for high end on X
M574 Y2 S1 P"^0.io6.in+^1.io0.in"                      ; configure active-high endstop for high end on Y
M574 U1 S1 P"^1.io2.in"                                ; configure active-high endstop for high end on U

; Z-Probe
M558 K0 P8 C"^!io1.in" R1.0 H5 F400 A7 S0.005 T24000
G31  K0 X0 Y0 Z0 P100
M558 K1 P8 C"^!1.io5.in" R1.0 H5 F400 A7 S0.005 T24000
G31  K1 X0 Y0 Z0 P100

M557 X0:325 Y5:355 P9                                  ; define mesh grid
M376 H2

; Filament sensor (BTT SFS 2.0)
M591 D0 P7 C"0.io3.in" L3 R50:150 E22 S1
M591 D1 P7 C"1.io1.in" L3 R50:150 E22 S1

; Pressure advance
M572 D0 S0.05
M572 D1 S0.05

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

; Fans (board cooling)
M950 F4 C"!1.out3" Q25000                              ; create fan and set its frequency
M106 P4 S1 H-1                                         ; set fan value (on).  Thermostatic control is turned off

; Bed Heater
M308 S0 P"temp0" Y"thermistor" T100000 B4092           ; configure sensor
M950 H0 C"out0" T0                                     ; create bed heater output and map it to sensor 0
M307 H0 R0.272 C349.6 D8.37 S1.00 V23.7
M140 H0                                                ; map heated bed to heater 0
M143 H0 S120                                           ; set temperature limit for heater 0 to 120C

; tool 0 thermistor
M308 S1 P"temp1" Y"thermistor" T100000 B4725 C7.06e-8  ; configure sensor
M950 H1 C"out1" T1                                     ; create nozzle heater output and map it to sensor 1

; tool 0
M307 H1 R4.042 K0.586:0.400 D2.02 E1.35 S1.00 B0 V23.8 ; ender-5 tuned (3.6.0) at 220, 5mm off the bed with part cooling fan
M563 P0 S"E3Dv6" D0 H1 F0                              ; define tool 0
G10 P0 X0 Y0 Z0                                        ; set tool 0 axis offsets

; tool 1 thermistor
M308 S2 P"1.temp2" Y"thermistor" T100000 B4725 C7.06e-8; configure sensor
M950 H2 C"1.out2" T2                                   ; create nozzle heater output and map it to sensor 2

; tool 1
M307 H2 R4.042 K0.586:0.400 D2.02 E1.35 S1.00 B0 V23.8 ; ender-5 tuned (3.6.0) at 220, 5mm off the bed with part cooling fan
M563 P1 S"E3Dv6" D1 H2 X3 F2                           ; define tool 1
G10 P1 X0.000 Y0.02 Z0.35 U-1.35                       ; set tool 1 axis offsets

; Set both tools to standby mode
M568 A1 P0 R0 S0
M568 A1 P1 R0 S0

; Tool (common)
G10 P0 R0 S0                                           ; set initial tool 0 active and standby temperatures to 0C
G10 P1 R0 S0                                           ; set initial tool 1 active and standby temperatures to 0C

; MCU DOES NOT WORK ON THE DUET 3 MINI 5+?
M912 P0 S-12.5                                         ; Calibrate MCU temperature

; Miscellaneous
M912 P0 S-1

M98 P"/sys/global-defaults.g"
