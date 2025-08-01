M550 P"taz6"                                              ; Set our hostname
M552 S1 ; P0.0.0.0                                          ; Enable the ethernet connection with DHCP IP address assignment
M554 P192.168.1.1

M98 P"/sys/global-declarations.g"

G90                                       ; send absolute coordinates...
M83                                       ; ...but relative extruder moves

; Drives
M569 P0 S1 D2
M569 P1 S1 D2
M569 P2 S0 D2
M569 P3 S0 D2
M569 P4 S0 D2

; Axis mapping
M584 X4 Y1 Z2:3 E0                        ; set drive mapping
M671 X370:-110 Y140:140                   ; leadscrew positions

; Steps and speeds
M350 X16 Y16 Z16 E16 I1                   ; configure microstepping with interpolation
M92 X100.50 Y100.50 Z1600.00 E2682        ; set steps per mm (830 for stock extruder)
M566 X480.00 Y480.00 Z24.00 E150 P1       ; set maximum instantaneous speed changes (mm/min)
M203 X18000.00 Y18000.00 Z400.00 E1500.00 ; set maximum speeds (mm/min)
M201 X500.00 Y500.00 Z20.00 E3000         ; set accelerations (mm/s^2)
M906 X950 Y950 Z1200 E450 I30             ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                   ; Set idle timeout

; Axis Limits
M208 X-20 Y-20 Z-1 S1                     ; set axis minima
; Printable area is 280x280 (minus the very corners?)
; Extra movement area is available intended for reaching the probe points
M208 X300 Y303 Z270 S0                    ; set axis maxima

; Endstops
M574 X1 S1 P"^io6.in"                       ; configure active-high endstop for low end on X via pin xstop
M574 Y2 S1 P"^io5.in"                       ; configure active-high endstop for high end on Y via pin ystop
M574 Z1 S1 P"!^io4.in"                      ; configure active-low endstop for low end on Z via pin zstop

; Z-Probe
M558 K0 P8 C"^!io3.in" R1.0 H5 F400 A7 S0.005 T24000
G31 X0 Y0 Z0 P25					  ; 

M557 X5:280 Y5:280 P13                     ; define mesh grid
M376 H3

; Filament sensor (BTT SFS 2.0)
M591 D0 P7 C"io2.in" L3 R75:125 E9 S1

; Bed heater
M308 S0 P"temp0" Y"thermistor" T100000 B3972 C7.060000e-8  ; configure sensor 0 as thermistor
M950 H0 C"out0" T0                        ; create bed heater output and map it to the sensor
M143 H0 S120                              ; set temperature limit for heater 0 to 120C
M140 H0                                   ; map heated bed to heater 0
; Heater 0 model: gain 130.2, time constant 313.5, dead time 1.8, max PWM 1.00, calibration voltage 23.9, mode PID, inverted no, frequency default
; Computed PID parameters for setpoint change: P236.6, I9.917, D300.8
; Computed PID parameters for load change: P2
M307 H0 A130.2 C313.5 D1.8 S1.00 V23.9 B0

; Hotend heater
M308 S1 P"temp1" Y"thermistor" T100000 B4725 C7.06e-8 ; configure sensor 1 as thermistor
M950 H1 C"out1" T1                        ; create nozzle heater output and map it to the sensor
M143 H1 S280                              ; set temperature limit for heater 1 to 280C
M307 H1 B0 R3.833 C186.9:99.6 D2.12 S1.00 V24.1

; Fans
M950 F0 C"out3" Q500
M106 P0 S1 H1 T45                         ; set fan 0 to be on by default but therm controlled, set to 5V

M950 F1 C"out5" Q500
M106 P1 S0 H-1                            ; set fan 2 off by default, not controlled, set to 24V

M308 S10 Y"mcu-temp" A"MCU"                            ; defines sensor 10 as MCU temperature sensor
M308 S11 Y"drivers" A"Duet stepper drivers"            ; defines sensor 11 as stepper driver temperature sensor
M950 F2 C"out4" Q500                                   ; create fan and set its frequency
M106 P2 S1 H-1  C"board"                               ; set fan value (on).  Thermostatic control is turned off
M106 P2 H10:11 T33 C"board"; set fan 2 value

; Tools
M563 P0 D0 H1 F1                          ; define tool 0
G10 P0 X0 Y0 Z0                           ; set tool 0 axis offsets
G10 P0 R0 S0                              ; set initial tool 0 active and standby temperatures to 0C

; Custom settings are not defined

M98 P"/sys/global-defaults.g"

; Miscellaneous
T0                                        ; select first tool
