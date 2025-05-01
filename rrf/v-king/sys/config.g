 ;
;
; T O D O
;
;
;

M98 P"/sys/global-declarations.g"

; General preferences
G90                                        ; Send absolute coordinates...
M83                                        ; ...but relative extruder moves

; MOTOR Section

M584 E0 X1 Y2:3 Z4:5:6                     ; set up the drive mapping

; Drive directions
M569 P1 S1 D2                              ; Drive 0 direction (e0) (Orbiter recommends disabling stealthchop, try disabling for all drivers)
M569 P1 S1 D2                              ; Drive 1 direction (x)
M569 P2 S1 D2                              ; Drive 2 direction (y back left)
M569 P3 S0 D2                              ; Drive 3 direction (y back right)
M569 P4 S1 D2                              ; Drive 4 direction (z front middle)
M569 P5 S1 D2                              ; Drive 5 direction (z back left) (expansion 1)
M569 P6 S1 D2                              ; Drive 6 direction (z back right) (expansion 2)

; The motor specifications say 0.067 degree / step.  Let's assume that is rounded and is really
; 0.0666... Give a degree/step we can say it takes (360/dps) steps to make a rotation, each
; rotation moves 40mm and we are doing x16 microstepping.  So, at 0.067 degree/step we get:
; 0.067 degree/step: 360/0.067/40*16 = 2,149.25
; But if we do: 360/.066666666666666666666666666666666666/40*16 = 2160
;
; Given that given enough repeating digits we get arbitrarily close to a round number,
; it sounds to me like that is the more likely value.  Use it.

M92 X160 Y160 Z2160 E680                   ; Set steps per mm at 1/16 micro stepping (E recommended is 690)
M350 X16 Y16 E16 I1                        ; Configure microstepping with interpolation for x/y/e
M350 Z16 I0                                ; Configure microstepping without interpolation for z

; Drive speeds and currents
M566 X300 Y300 Z240 E300 P1                ; Set maximum instantaneous speed changes (mm/min)
M203 X24000 Y24000 Z600 E7200              ; Set maximum speeds (mm/min)
M201 X3500 Y3500 Z500 E5000                ; Set accelerations (mm/s^2)
M906 X1200 Y1000 Z840 I30                  ; Set motor currents (mA) and motor idle factor in per cent
M906 E850 I10                              ; (orbiter supposed to be 1200)
M84 S30                                    ; Set idle timeout

; Z "leadscrew" positions
M671 X180:4:336 Y8:395:395 S10             ; motor order: front middle, back left, back right

; Endstops
M574 X1 S1 P"!io6.in"                      ; x endstop (low end)
M574 Y2 S1 P"!io5.in+!io3.in"              ; 2 y endstops (high end)

; Axis Limits
M208 X-16 Y-12 Z-5 S1                      ; Set axis minima
M208 X353 Y372 Z390 S0                     ; Set axis maxima

; Z-Probe
M558 K0 P8 C"^!io1.in" R1.0 H5 F400 A5 T24000
G31 X0 Y0 Z0 P100
M557 X50:300 Y50:350 P11                   ; Define mesh grid
M376 H6                                   ; Taper compensation over 6mm height, good for up to 0.3mm error @ < 5% extrusion error

; Filament sensor (BTT SFS 2.0)
M591 D0 P7 C"io0.in" L2.975 R50:150 E22 S1

; Accelerometer
;M955 P0 C"io4.out+io4.in"
;M593 P"ZVD" F83       ; does it do anything for me?

; Pressure advance
M572 D0 S0.05

; Bed Heater
M308 S0 P"temp0" Y"thermistor" T100000 B4138 ; configure sensor 0 as thermistor on pin bedtemp
M950 H0 C"out0" T0                         ; create bed heater output on bedheat and map it to sensor 0
M140 H0
M143 H0 S120                               ; Set temperature limit for heater 0 to 120C
M307 H0 A159.7 C501.4 D3.1 V24.2 B0

; Hotend Heater
M308 S1 P"temp2" Y"thermistor" T100000 B4725 C7.06e-8 ; configure sensor 1 as thermistor on pin e0temp
M950 H1 C"out1" T1                       ; create nozzle heater output on e0heat
M143 H1 S280                               ; Set temperature limit for heater 1 to 280C
;M307 H1 R3.794 K0.628:0.300 D1.54 E1.35 S1.00 B0 V24.4 ; revo @ 255
M307 H1 B0 R2.593 C211.1:173.4 D5.20 S1.00 V24.1       ; [from ender-5] tuned (new) at 255 10mm off the bed with the part cooling fan

; Fans
; heatend fan is on always on fan due to fan0 being dead
M950 F0 C"out5" Q500
M106 P0 S0                                 ; part cooling fan off by default
M950 F1 C"out4" Q500
M106 P1 S1 T45 H1                          ; hotend fan turned on/off based on extruder temp

; Tools
M563 P0 D0 H1 F0                           ; Define tool 0
G10 P0 X0 Y0 Z0                            ; Set tool 0 axis offsets
G10 P0 R0 S0                               ; Set initial tool 0 active and standby temperatures to 0C

; Pressure advance
; M572 D0 S0.2

; Automatic saving after power loss is not enabled

; Custom settings are not configured

; Miscellaneous
M912 P0 S1.2                               ; MCU temperature calibration
T0                                         ; Select first tool

M98 P"/sys/global-defaults.g"