M550 P"veho"                                              ; Set our hostname
M552 S1 P0.0.0.0                                          ; Enable the ethernet connection with DHCP IP address assignment
M554 P192.168.1.1

M98 P"/sys/global-declarations.g"
M98 P"/sys/mqtt-enable.g"

G4 S2 ; wait for expansion boards to start

; General preferences
G90                                                    ; send absolute coordinates...
M83                                                    ; ...but relative extruder moves

; Drives
M569 P0.0 S0 ; D3                                        ; x
M569 P0.1 S0 ; D3                                        ; z1 (front left)
M569 P0.2 S0 ; D3                                        ; z2 (back left)
M569 P0.3 S0 ; D3                                        ; z4 (front right)
M569 P0.4 S1 ; D3                                        ; z3 (back right)
M569 P0.5 S1 ; D3                                        ; y1 (left)
M569 P0.6 S1 ; D3                                        ; y2 (right)
M569 P121.0 S1 ; D3                                      ; e

M584 X0.0 Y0.6:0.5 Z0.1:0.2:0.4:0.3 E121.0               ; set drive mapping

; Z leadscrew positions
M671 X50:50:550:550 Y50:550:550:50 S5

M92 X53.33 Y53.33 Z600 E680                            ; set steps per mm (recommended; 690 orbiter)
M350 X16 Y16 Z16 E16 I1                                ; Configure microstepping with interpolation

M566 X300.00 Y300.00 Z240.00 E300 P1                   ; set maximum instantaneous speed changes (mm/min)
M203 X24000.00 Y24000.00 Z600.00 E7200                 ; set maximum speeds (mm/min)
M201 X2500.00 Y2500.00 Z200.00 E5000                   ; set accelerations (mm/s^2)
M906 X1200 Y1200 Z1200 E900 I30                        ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                                ; Set idle timeout

; Axis Limits
M208 X0 Y0 Z0 S1                                       ; set axis minima
M208 X625 Y600 Z650 S0                                 ; set axis maxima

; Endstops
M574 X2 S1 P"!121.io2.in"                              ; configure active-high endstop for low end on X
M574 Y2 S1 P"^0.io5.in+^0.io6.in"                      ; configure active-low endstop for high end on Y

; Z-Probe
M558 P8 C"^!121.io1.in" A5 R1 H5 F400 T24000
G31 X0 Y0 Z0 P100
;M557 X100:500 Y100:500 P9                              ; define mesh grid for 500x500 bed
M557 X25:575 Y25:575 P13                                ; define mesh grid for 600x600 bed
M376 H3

; Filament sensor (BTT SFS 2.0)
M591 D0 P7 C"121.io0.in" L3 R75:125 E9 S1
;M591 D0 P7 C"io4.in" P1 S1

; Accelerometer (toolboard), input shaping and pressure advance
M955 P121.0 I10                                        ; Z+ -> Y+ and X+ -> X+
M593 P"zvd" F45 S0.1
M572 D0 S0.05

; Fans (tool 0)
M950 F0 C"121.out1" Q250                               ; create fan and set its frequency
M106 P0 S0 H-1 C"part"                                 ; set fan value (off). Thermostatic control is turned off
M950 F1 C"121.out2" Q500                               ; create fan and set its frequency
M106 P1 S1 T45 H1 C"hotend"                            ; set fan value (on). Thermostatic control is turned on

; Fans (board cooling)
M308 S10 Y"mcu-temp" A"MCU"                            ; defines sensor 10 as MCU temperature sensor
M308 S11 Y"drivers" A"Duet stepper drivers"            ; defines sensor 11 as stepper driver temperature sensor
M950 F2 C"out5" Q500                                   ; create fan and set its frequency
M106 P2 S1 H-1  C"board"                               ; set fan value (on).  Thermostatic control is turned off
M106 P2 H10:11 T33 C"board"; set fan 2 value

; Bed Heater
;M308 S0 P"temp0" Y"thermistor" T100000 B4734 C1.153746e-7 ; configure sensor
M308 S0 P"temp0" Y"thermistor" T100000 B3950 ; configure sensor
M950 H0 C"out0" T0                                     ; create bed heater output and map it to sensor 0
M307 H0 R0.212 K0.115:0.000 D9.15 E1.35 S1.00 B0
M140 H0                                                ; map heated bed to heater 0
M143 H0 S120                                           ; set temperature limit for heater 0 to 120C

; thermistor (e3d)
M308 S1 P"121.temp0" Y"thermistor" T100000 B4725 C7.06e-8  ; configure sensor
M950 H1 C"121.out0" T1                                     ; create nozzle heater output and map it to sensor 1

; revo 40w
M307 H1 R3.488 K0.464:0.226 D1.62 E1.35 S1.00 B0 V24.1
M563 P0 S"E3Dv6" D0 H1 F0                              ; define tool 0
G10 P0 R0 S0                                           ; Set initial tool 0 active and standby temperatures to 0C

; Servo for klicky
;M950 S1 C"out6" ; assign GPIO port 1 to out9 (Servo header), servo mod
;M280 P1 S{global.klicky_servo_down}

; Miscellaneous
M912 P0 S0
T0

M98 P"/sys/global-defaults.g"
