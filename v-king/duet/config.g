; Configuration file for Duet Maestro (firmware version 1.21)
; executed by the firmware on start-up
;
; generated by RepRapFirmware Configuration Tool v2 on Fri Jan 04 2019 20:46:36 GMT-0500 (Eastern Standard Time)

; General preferences
G90                                        ; Send absolute coordinates...
M83                                        ; ...but relative extruder moves

M667 S1                                    ; Select CoreXY mode

; Network
M550 P"v-king"                             ; Set machine name
M98 P/sys/passwords.g
M553 P255.255.255.0			   ; Set netmask
M554 P192.168.1.1                          ; Set gateway
M552 P192.168.1.8 S1                       ; Enable network
M586 P0 S1                                 ; Enable HTTP
M586 P1 S0                                 ; Disable FTP
M586 P2 S0                                 ; Disable Telnet

; Endstops
M574 X1 Y1 Z1 S1                           ; Set active high x/y/z min endstops

; Drive directions
M569 P0 S1                                 ; Drive 0 goes forwards (x)
M569 P1 S1                                 ; Drive 1 goes forwards (y)
M569 P2 S1                                 ; Drive 2 goes forwards (z back-left)
M569 P3 S1                                 ; Drive 3 goes forwards (e0)
M569 P5 S1                                 ; Drive 5 goes forwards (z back-right)
M569 P5 S1                                 ; Drive 6 goes forwards (z front)

; Z drive setup
M584 X0 Y1 Z2:5:6                          ; three Z motors connected to driver outputs 2, 5 and 6
M671 X56.5:308:182.5 Y445:445:-75 S0.5

; Drive steps per mm
; z = 360/0.067/40*16*2 = 4298.5
; 0.067 is step angle from spec sheet, 40 = belt mm for 1 full rotation, 16 micro stepping, 2 = "double belt resolution"
; but it only moved 46mm when requested to move 50mm which would then be adjusted to 4672.3
;M92 X160 Y160 Z4298.5 E2872                ; Set steps per mm at 1/16 micro stepping
M92 X160 Y160 Z4298.5 E415                ; Set steps per mm at 1/16 micro stepping
M350 X32 Y32 Z16 E16 I0                 ; Configure microstepping without interpolation

; Drive speeds and currents
M566 X600 Y600 Z18 E300:300                ; Set maximum instantaneous speed changes (mm/min)
M203 X24000 Y24000 Z120 E6000:6000         ; Set maximum speeds (mm/min)
M201 X2000 Y2000 Z500 E1500:1500          ; Set accelerations (mm/s^2)
M906 X1200 Y1200 Z600 E750:750 I30         ; Set motor currents (mA) and motor idle factor in per cent
M84 S30                                    ; Set idle timeout

; Axis Limits
M208 X0 Y0 Z-5 S1                          ; Set axis minima
M208 X325 Y380 Z340 S0                     ; Set axis maxima

; Z-Probe
M98 P/sys/zprobe.g
M557 X0:310 Y0:360 S77.5:72               ; Define mesh grid

; Heaters
M307 H0 B0 S1.00                           ; Disable bang-bang mode for the bed heater and set PWM limit
M305 P0 T100000 B4388 R2200                 ; Set thermistor + ADC parameters for heater 0
M143 H0 S120                               ; Set temperature limit for heater 0 to 120C
M305 P1 T100000 B4388 C7.060000e-8 R2200   ; Set thermistor + ADC parameters for heater 1
M143 H1 S280                               ; Set temperature limit for heater 1 to 280C

; Fans
; DEAD: M106 P0 S0 I0 F500 H-1                     ; part cooling fan: PWM signal inversion and frequency. Thermostatic control is turned off
; TEMPORARILY MOVED TO ALWAYS ON: M106 P1 S1 I0 F500 H1 T35                  ; hotend fan: PWM signal inversion and frequency. Thermostatic control is turned on
M106 P1 S0 I0 H-1
M106 P2 S1 I0 F500 H-1                     ; case fan: PWM signal inversion and frequency. Thermostatic control is turned off, Fan on

; Tools
M563 P0 D0 H1 F1                           ; Define tool 0
G10 P0 X0 Y0 Z0                            ; Set tool 0 axis offsets
G10 P0 R0 S0                               ; Set initial tool 0 active and standby temperatures to 0C

; Automatic saving after power loss is not enabled

; Custom settings are not configured

; Miscellaneous
T0                                         ; Select first tool