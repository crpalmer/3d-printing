;
; Parse the parameters
;

var t1_temp = 0
var t2_temp = 0
var bed_temp = 0

if exists(tools[1])
  if ! exists(param.H) || ! exists(param.I) || ! exists(param.B) || ! exists(param.C)
    echo "Missing required parameter (H/I and B/C)"
    M99
  set var.t1_temp = param.H
  set var.t2_temp = param.I
  set var.bed_temp = max(param.B, param.C)
else
  if ! exists(param.H) || ! exists(param.B)
    echo "Missing required parameter (H and B)"
    M99
  set var.t1_temp = param.H
  set var.bed_temp = param.B

if var.t1_temp <= 0 && var.t2_temp <= 0
   M98 P"/sys/mqtt-message.g" S"No hotend has a temperature to print at" F1

;
; Determine any required temperatures for probing
;

var t1_probe_temp = var.t1_temp - global.probe_at_temperature_delta
var t2_probe_temp = 0

if exists(sensors.probes[1]) && global.probe_at_temperature_delta != null
  set var.t2_probe_temp = var.t2_temp - global.probe_at_temperature_delta
elif var.t1_temp <= 0 && global.probe_at_temperature_delta != null
  set var.t1_probe_temp = var.t2_temp - global.probe_at_temperature_delta

var bed_probe_temp = var.bed_temp

;
; Start the hotend(s) heating
;

if var.t1_probe_temp > 0
  M568 A1 P0 R{var.t1_probe_temp} S{var.t1_probe_temp}
else
  M568 A1 P0 R{var.t1_temp} S{var.t1_temp}

if exists(tools[1])
  if  var.t2_probe_temp > 0
    M568 A1 P1 R{var.t2_probe_temp} S{var.t2_probe_temp}
  else
    M568 A1 P1 R{var.t2_temp} S{var.t2_temp}

;
; Reset the state / initialize things
;

M220 S100     ; clear any speed changes
M290 R0 S0    ; clear any baby stepping
M106 S0       ; disable fans
G29 S2        ; disable mesh compensation

set global.last_wipe = { 0, 0 }

;
; Wait for the required temperatures
;

M190 R{var.bed_probe_temp}    ; Wait to get up (or down!) to the right temperature
if var.t1_probe_temp > 0
   M116 P0                    ; Wait for the hotend to reach its temp
if var.t2_probe_temp > 0
   M116 P1
M561

;
; Home x/y/z/u
;

T0
if var.t1_probe_temp <= 0
  G10 P1 Z0        ; We are probing Z with our own probe, it doesn't need to be offset
G28 X U
G28 Y
T{var.t1_probe_temp > 0 ? 0 : 1}
M98 P"/sys/wipe-for-probing.g"
M98 P"/sys/homez-with-retry.g"
G1 Z5
if var.t1_probe_temp > 0 && var.t2_probe_temp > 0
  M98 P"/sys/idex-calibration.g"
  T0

;
; Handle any bed compensation/leveling
;

if global.use_true_bed_leveling
  G32
  M98 P"/sys/homez-with-retry.g"

if global.use_mesh_compensation
  G29 S1

M290 R0 S{-global.probe_extra_squish}
;
; Finish up
;

if var.t1_probe_temp != var.t1_temp
  M568 A{state.currentTool == 0 ? 2 : 1} P0 R{var.t1_temp} S{var.t1_temp}
if var.t2_probe_temp != var.t2_temp
  M568 A{state.currentTool == 1 ? 2 : 1} P1 R{var.t2_temp} S{var.t2_temp}

if var.bed_probe_temp < var.bed_temp
   M140 S{var.bed_temp}

;
; Park the toolhead and then wait for all temperatures to be reached.
;

M98 P"/sys/park-hotends.g"
M116 H0
M116 P0
if exists(tools[1])
  M116 P1
