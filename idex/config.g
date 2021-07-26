;
; TODO
;

; -------------------------


; General preferences
G90                                                    ; send absolute coordinates...
M83                                                    ; ...but relative extruder moves

; Drives
M569 P0 S1                                             ; physical drive 0 goes forwards (stock x)
M569 P1 S0                                             ; physical drive 1 goes backwards
M569 P2 S0                                             ; physical drive 2 goes backwards
M569 P3 S1                                             ; physical drive 3 goes forwards (bondtech)
M569 P4 S0                                             ; physical drive 4 goes backwards
M584 X0 Y1 E3 Z2:4                                     ; set drive mapping: Z motors 2 (z) and 4 (e1)
M92 X80.00 Y80.00 Z1600.00 E830                        ; set steps per mm (should be e415, tlm had e398.1,i though 404.5?)*2(0.9degree stepper)
M350 X16 Y16 Z16 E16 I1                                ; set microstepping to 256 interpolation
M566 X600.00 Y600.00 Z18.00 E1000.00                   ; set maximum instantaneous speed changes (mm/min) (bondtech)
M203 X12000.00 Y12000.00 Z360.00 E3600.00              ; set maximum speeds (mm/min) (bondtech)
M201 X500.00 Y500.00 Z100.00 E1000.00                  ; set accelerations (mm/s^2) (bondtech)
M906 X800 Y1200 Z1200 E700 I30                         ; set motor currents (mA) and motor idle factor in per cent (bondtech)
M84 S30                                                ; Set idle timeout

; Axis Limits
M208 X0 Y0 Z0 S1                                       ; set axis minima
M208 X350 Y350 Z420 S0                                 ; set axis maxima

; Endstops
M574 X2 S1 P"xstop"                                    ; configure active-high endstop for high end on X via pin xstop
M574 Y2 S1 P"ystop"                                    ; configure active-high endstop for high end on Y via pin ystop

; Z-Probe
M950 S0 C"exp.heater3"                                 ; servo pin definition
M558 P9 C"^zprobe.in" H5 F100 T2000
G31 X27.5 Y0 Z1.975 P25 ; (V6 + glass bed)
M557 X5:200 Y5:200 P7                                ; define mesh grid

; Fans
M950 F0 C"fan0" Q250                                   ; create fan 0 on pin fan0 and set its frequency
M106 P0 S0 H-1                                         ; set fan 0 value. Thermostatic control is turned off
M950 F1 C"fan1" Q500                                   ; create fan 1 on pin fan1 and set its frequency
M106 P1 S1 T45 H1                                      ; set fan 1 value. Thermostatic control is turned on

; Bed Heater
M308 S0 P"bedtemp" Y"thermistor" T100000 B4092         ; configure sensor 0 as thermistor on pin bedtemp
M950 H0 C"bedheat" T0                                  ; create bed heater output on bedheat and map it to sensor 0
M307 H0 B0 S1.00 A158.7 C330.4 D1.2 V23.8              ; TODO: bed pid tuned @ 70
M140 H0                                                ; map heated bed to heater 0
M143 H0 S120                                           ; set temperature limit for heater 0 to 120C

; e3dv6
M308 S1 P"e0temp" Y"thermistor" T100000 B4725 C7.06e-8 ; configure sensor 1 as thermistor on pin e0temp
M950 H1 C"e0heat" T1                                   ; create nozzle heater output on e0heat and map it to sensor 1
M307 H1 B0 S1.00 A402.8 C235.9 D3.7 V23.9              ; TODO: standard v6: nozzle pid tuned at 250
M563 P0 S"E3Dv6" D0 H1 F0                              ; define tool 0

; Tool (common)
G10 P0 X0 Y0 Z0                                        ; set tool 0 axis offsets
G10 P0 R0 S0                                           ; set initial tool 0 active and standby temperatures to 0C

; Custom settings are not defined
; TODO M912 P0 S-12.5                                         ; Calibrate MCU temperature

; Miscellaneous
T0                                                     ; select first tool

