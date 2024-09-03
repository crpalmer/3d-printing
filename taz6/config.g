; Configuration file for Duet Maestro (firmware version 2.03)
; executed by the firmware on start-up
;
; generated by RepRapFirmware Configuration Tool v2.1.3 on Sun Dec 01 2019 12:21:58 GMT-0500 (Eastern Standard Time)

; Configuration

; Network - START THE NETWORK BEFORE ANYTHING ELSE IN CASE OF ERRORS
;
; If you have an error before the network starts you'll need to remove the sdcard
; to be able to fix the error because you won't be able to access the web console!

M550 P"taz6"                              ; set printer name
M98 P"password.g"
M551 P"reprap"
M552 P0.0.0.0 S1                          ; enable network and acquire dynamic address via DHCP
M586 P0 S1                                ; enable HTTP
M586 P1 S0                                ; disable FTP
M586 P2 S0                                ; disable Telnet

global klicky_is_manual = false
global klicky_safe_x = 50
global klicky_safe_y = -10
global klicky_pre_x = -1
global klicky_pre_y = -10
global klicky_z = 12.5
global klicky_dock_x = global.klicky_pre_x
global klicky_dock_y = 14
global klicky_release_x = global.klicky_dock_x + 50
global klicky_release_y = global.klicky_dock_y
global klicky_servo_up = 1350
global klicky_servo_down = 690
global klicky_n_deploys = 0

global hotend_revo_roto = 1
global hotend_itworks3d = 2

global hotend = global.hotend_revo_roto
;global hotend = global.hotend_itworks3d

if global.hotend == global.hotend_revo_roto
  global extruder_current = 450
  global extruder_direction = 1             ; forward
  global extruder_jerk = 150                ; 2.5 mm/sec
  global extruder_acceleration = 3000
  global extruder_steps_per_mm = 2682

  global zprobe_offset_x = 0
  global zprobe_offset_y = 20
  global zprobe_offset_z = 3.2
elif global.hotend == global.hotend_itworks3d
  global extruder_current = 750
  global extruder_direction = 1             ; forward
  global extruder_jerk = 600                ; 10 mm/sec
  global extruder_acceleration = 250
  global extruder_steps_per_mm = 413

  global zprobe_offset_x = 0
  global zprobe_offset_y = -44
  global zprobe_offset_z = 2.8
  global zprobe_
; General preferences
G90                                       ; send absolute coordinates...
M83                                       ; ...but relative extruder moves

; Drives
M569 P0 S0 D2                             ; physical drive 0 goes backward
M569 P1 S1 D2                             ; physical drive 1 goes forward
M569 P2 S0 D2                             ; physical drive 2 goes backward
M569 P3 S{global.extruder_direction} D2
M569 P4 S0 D2                             ; physical drive 2 goes backward

; Axis mapping
M584 X0 Y1 Z2:4 E3                        ; set drive mapping
M671 X370:-110 Y140:140                   ; leadscrew positions

; Steps and speeds
M350 X16 Y16 Z16 E16 I1                   ; configure microstepping with interpolation
M92 X100.50 Y100.50 Z1600.00 E{global.extruder_steps_per_mm}      ; set steps per mm (830 for stock extruder)
M566 X480.00 Y480.00 Z24.00 E{global.extruder_jerk} P1      ; set maximum instantaneous speed changes (mm/min)
M203 X18000.00 Y18000.00 Z180.00 E1500.00 ; set maximum speeds (mm/min)
M201 X500.00 Y500.00 Z20.00 E{global.extruder_acceleration}       ; set accelerations (mm/s^2)
M906 X950 Y950 Z1200 E{global.extruder_current} I30             ; set motor currents (mA) and motor idle factor in per cent
M84 S30                                   ; Set idle timeout

; Axis Limits
M208 X-20 Y-20 Z-1 S1                     ; set axis minima
; Printable area is 280x280 (minus the very corners?)
; Extra movement area is available intended for reaching the probe points
M208 X300 Y303 Z270 S0                    ; set axis maxima

; Endstops
M574 X1 S1 P"xstop"                       ; configure active-high endstop for low end on X via pin xstop
M574 Y2 S1 P"ystop"                       ; configure active-high endstop for high end on Y via pin ystop
M574 Z1 S1 P"!zstop"                      ; configure active-low endstop for low end on Z via pin zstop

; Z-Probe
M950 S0 C"zprobe.mod"                     ; servo pin definition
M558 P9 C"^zprobe.in" H5 F200 T6000
G31 X{global.zprobe_offset_x} Y{global.zprobe_offset_y} Z{global.zprobe_offset_z} P25					  ; 

var min_x = max(5+global.zprobe_offset_x, 5)
var max_x = min(280, 280+global.zprobe_offset_x)
var min_y = max(5+global.zprobe_offset_y, 5)
var max_y = min(280, 280+global.zprobe_offset_y)

M557 X{var.min_x}:{var.max_x} Y{var.min_y}:{var.max_y} P13                     ; define mesh grid
M376 H3

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

if global.hotend == global.hotend_revo_roto
  M307 H1 B0 R3.833 C186.9:99.6 D2.12 S1.00 V24.1
else
  ; ItWorks3d titan aero -- use this as a fallback for all other
  ; toolheads as it is tuned using old algorithms for the V6 (aka, pretty generic)
  M307 H1 A502.2 C320.7 D4 V24.1 B0

; Fans
M950 F0 C"fan0" Q500
M106 P0 S1 H1 T45                         ; set fan 0 to be on by default but therm controlled, set to 5V
; Fan 1 is set to 5V but unused
M950 F2 C"fan2" Q500
M106 P2 S0 H-1                            ; set fan 2 off by default, not controlled, set to 24V

; Tools
M563 P0 D0 H1 F2                          ; define tool 0
G10 P0 X0 Y0 Z0                           ; set tool 0 axis offsets
G10 P0 R0 S0                              ; set initial tool 0 active and standby temperatures to 0C

; Custom settings are not defined

; Miscellaneous
M280 P0 S{global.klicky_servo_down}
T0                                        ; select first tool
