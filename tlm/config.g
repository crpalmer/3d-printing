; General preferences
G90                                                      ; send absolute coordinates...
M83                                                      ; ...but relative extruder moves
; Diagonals 400.360:400.360:400.360, delta radius 170.271, homed height 533.507, bed radius 160.0, X 0.018°, Y -0.043°, Z 0.000°
M665 R170.271 L400.36 B160 H533.507 X0.018 Y-0.043
; Endstop adjustments X-0.91 Y0.59 Z0.32, tilt X0.00% Y0.00%
M666 X-0.91 Y0.59 Z0.32

; Network
M550 P"tlm"
M552 S1                                                  ; enable network
M586 P0 S1                                               ; enable HTTP
M586 P1 S0                                               ; disable FTP
M586 P2 S0                                               ; disable Telnet

; Drives
M569 P0 S0                                               ; physical drive 0 goes backwards
M569 P1 S0                                               ; physical drive 1 goes backwards
M569 P2 S0                                               ; physical drive 2 goes backwards
M569 P3 S0                                               ; physical drive 3 goes backwards
M584 X0 Y1 Z2 E3                                         ; set drive mapping
M92 X160.00 Y160.00 Z160.00 E830.00                      ; set steps per mm
M350 X16 Y16 Z16 E16 I1                                  ; configure microstepping with interpolation (E should be 830 but old tlm had 809)
M566 X1200.00 Y1200.00 Z1200.00 E1200.00                 ; set maximum instantaneous speed changes (mm/min)
M203 X20000.00 Y20000.00 Z20000.00 E3600.00              ; set maximum speeds (mm/min)
M201 X1000.00 Y1000.00 Z1000.00 E1000.00                 ; set accelerations (mm/s^2)
M906 X1200 Y1200 Z1200 E1000 I30                          ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                                  ; Set idle timeout

; Axis Limits
M208 Z-10 S1                                              ; set minimum Z

; Endstops
M574 X2 S1 P"!xstop"                                      ; configure NO endstop for low end on X via pin xstop
M574 Y2 S1 P"!ystop"                                      ; configure NO endstop for low end on Y via pin ystop
M574 Z2 S1 P"!zstop"                                      ; configure NO endstop for low end on Z via pin zstop

; Z-Probe
M558 P8 R1.4 C"zprobe.in+zprobe.mod" F1200 H5 A31 S0.02  ; set Z probe type to effector and the dive height + speeds
G31 P100 X0 Y0 Z-0.05                                    ; set Z probe trigger value, offset and trigger height (was 0.1)
M557 R125 S20                                            ; define mesh grid

; Heaters
M308 S0 P"bedtemp" Y"thermistor" T100000 B4148 C2.117e-7 ; configure sensor 0 as thermistor on pin bedtemp
M950 H0 C"bedheat" T0                                    ; create bed heater output on bedheat and map it to sensor 0
M307 H0 A354.5 C721.7 D3.7 V24.1 S1.00                   ; disable bang-bang mode for the bed heater and pid parameters (@ 60)
M140 H0                                                  ; map heated bed to heater 0
M143 H0 S120                                             ; set temperature limit for heater 0 to 120C
M308 S1 P"e0temp" Y"thermistor" T100000 B4725 C7.06e-8   ; configure sensor 1 as thermistor on pin e0temp
M950 H1 C"e0heat" T1                                     ; create nozzle heater output on e0heat and map it to sensor 1
M307 H1 A520.6 C244.7 D5.0 V23.8 B0 S1.00                ; disable bang-bang mode for heater and pid parameters (@ 245)
                                                         ; Heater 1 model: gain 520.6, time constant 244.7, dead time 5.0, max PWM 1.00, calibration voltage 23.8, mode PID

; Fans
M950 F0 C"fan1" Q500                                     ; create fan 0 on pin fan1 and set its frequency
M106 P0 S0 H-1                                           ; set fan 0 value. Thermostatic control is turned off
M950 F1 C"fan2" Q500                                     ; create fan 1 on pin fan2 and set its frequency
M106 P1 S1 H1 T45                                        ; set fan 1 value. Thermostatic control is turned on

; Tools
M563 P0 D0 H1 F0                                         ; define tool 0
G10 P0 X0 Y0 Z0                                          ; set tool 0 axis offsets
G10 P0 R0 S0                                             ; set initial tool 0 active and standby temperatures to 0C

T0