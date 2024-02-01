; Configuration file for Duet Maestro (firmware version 2.03)
; executed by the firmware on start-up
;
; generated by RepRapFirmware Configuration Tool v2.1.3 on Sun Dec 01 2019 12:21:58 GMT-0500 (Eastern Standard Time)

; General preferences
G90                                       ; send absolute coordinates...
M83                                       ; ...but relative extruder moves
M550 P"taz6"                              ; set printer name

; Network
M98 P"password.g"
M551 P"reprap"
M552 P0.0.0.0 S1                          ; enable network and acquire dynamic address via DHCP
M586 P0 S1                                ; enable HTTP
M586 P1 S0                                ; disable FTP
M586 P2 S0                                ; disable Telnet

; Drives
M569 P0 S0 D2                             ; physical drive 0 goes backward
M569 P1 S1 D2                             ; physical drive 1 goes forward
M569 P2 S0 D2                             ; physical drive 2 goes backward
M569 P3 S1 D2                             ; physical drive 3 goes forward
M569 P4 S0 D2                             ; physical drive 2 goes backward

; Axis mapping
M584 X0 Y1 Z2:4 E3                        ; set drive mapping
M671 X370:-110 Y140:140                   ; leadscrew positions

; Steps and speeds
M350 X16 Y16 Z16 E16 I1                   ; configure microstepping with interpolation
M92 X100.50 Y100.50 Z1600.00 E413.00      ; set steps per mm (830 for stock extruder)
M566 X480.00 Y480.00 Z24.00 E600.00       ; set maximum instantaneous speed changes (mm/min)
M203 X18000.00 Y18000.00 Z180.00 E1500.00 ; set maximum speeds (mm/min)
M201 X500.00 Y500.00 Z20.00 E250.00       ; set accelerations (mm/s^2)
M906 X950 Y950 Z1200 E750 I30             ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                   ; Set idle timeout

; Axis Limits
M208 X-20 Y-20 Z-1 S1                     ; set axis minima
M208 X300 Y303 Z270 S0                    ; set axis maxima

; Endstops
M574 X1 S1 P"xstop"                       ; configure active-high endstop for low end on X via pin xstop
M574 Y2 S1 P"ystop"                       ; configure active-high endstop for high end on Y via pin ystop
M574 Z1 S1 P"!zstop"                      ; configure active-low endstop for low end on Z via pin zstop

; Z-Probe
M950 S0 C"zprobe.mod"                     ; servo pin definition
M558 P9 C"^zprobe.in" H5 F100 T2000
G31 X0 Y-44 Z2.8 P25					  ; 
M557 X5:245 Y5:245 P9                     ; define mesh grid

; Bed heater
M308 S0 P"bedtemp" Y"thermistor" T100000 B3972 C7.060000e-8  ; configure sensor 0 as thermistor on pin bedtemp
M950 H0 C"bedheat" T0                     ; create bed heater output on bedheat and map it to sensor 0
M143 H0 S120                              ; set temperature limit for heater 0 to 120C
M140 H0                                   ; map heated bed to heater 0
; Heater 0 model: gain 130.2, time constant 313.5, dead time 1.8, max PWM 1.00, calibration voltage 23.9, mode PID, inverted no, frequency default
; Computed PID parameters for setpoint change: P236.6, I9.917, D300.8
; Computed PID parameters for load change: P2
M307 H0 A130.2 C313.5 D1.8 S1.00 V23.9 B0

; Hotend heater
M308 S1 P"e0temp" Y"thermistor" T100000 B4725 C7.06e-8 ; configure sensor 1 as thermistor on pin e0temp
M950 H1 C"e0heat" T1                      ; create nozzle heater output on e0hea
M143 H1 S280                              ; set temperature limit for heater 1 to 280C

; Stock hotend
; Heater 1 model: gain 187.6, time constant 126.7, dead time 0.9, max PWM 1.00, calibration voltage 24.2, mode PID, inverted no, frequency default
; Computed PID parameters for setpoint change: P139.2, I13.300, D84.4
; Computed PID parameters for load change: P1
;M307 H1 A187.6 C126.7 D0.9 S1.00 V24.2 B0

; ItWorks3d titan aero
; Heater 1 model: gain 502.2, time constant 320.7, dead time 4.0, max PWM 1.00, calibration voltage 24.1, mode PID, inverted no, frequency default
; Computed PID parameters for setpoint change: P28.2, I0.785, D79.8
; Computed PID parameters for load change: P28.
M307 H1 A502.2 C320.7 D4 V24.1 B0

; Fans
M950 F0 C"fan0" Q500
M106 P0 S1 H1 T45                         ; set fan 0 to be on by default but therm controlled
M950 F2 C"fan2" Q500
M106 P2 S0 H-1                            ; set fan 2 off by default, not controlled

; Tools
M563 P0 D0 H1 F2                          ; define tool 0
G10 P0 X0 Y0 Z0                           ; set tool 0 axis offsets
G10 P0 R0 S0                              ; set initial tool 0 active and standby temperatures to 0C

; Custom settings are not defined

; Miscellaneous
T0                                        ; select first tool

