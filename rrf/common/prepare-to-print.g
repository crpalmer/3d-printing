;
; Parse the parameters
;

var t1_temp = 0
var t2_temp = 0
var bed_temp = 0

if exists(tools[1])
  if exists(param.H) == false or exists(param.I) == false or exists(param.B) == false or exists(param.C) == false
    echo "Missing required parameter (H/I and B/C)"
    M99
  set var.t1_temp = param.H
  set var.t2_temp = param.I
  set var.bed_temp = max(param.B, param.C)
else
  if exists(param.H) == false or exists(param.B) == false
    echo "Missing required parameter (H and B)"
    M99
  set var.t1_temp = param.H
  set var.bed_temp = param.B

if var.t1_temp <= 0 && var.t2_temp <= 0
   abort "No hotend has a temperature to print at"

;
; Determine any required temperatures for probing
;

var t1_probe_temp = var.t1_temp - 50
var t2_probe_temp = 0

if exists(sensors.probes[1])
  set var.t2_probe_temp = var.t2_temp * global.probe_at_temperature_pct
elif var.t1_temp <= 0
  set var.t1_probe_temp = var.t2_temp * global.probe_at_temperature_pct

var bed_probe_temp = var.bed_temp
if global.probe_is_klicky
  set var.bed_probe_temp = min(var.bed_probe_temp, 60)

;
; Start the hotend(s) heating
;

if var.t1_probe_temp > 0
  M568 A1 P0 R{var.t1_probe_temp} S{var.t1_probe_temp}
else
  M568 A1 P0 R{var.t1_temp} S{var.t1_temp}
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
if global.probe_is_klicky
  M98 P"/sys/homexy.g"
  T0
  M401
  G28 Z
else
  if var.t1_probe_temp <= 0
    G10 P1 Z0        ; We are probing Z with our own probe, it doesn't need to be offset
  G28 X U
  G28 Y
  T{var.t1_probe_temp > 0 ? 0 : 1}
  M98 P"/sys/wipe-for-probing.g"
  G28 Z
  G1 Z5
  if var.t1_probe_temp > 0 && var.t2_probe_temp > 0
    T1
    M98 P"/sys/wipe-for-probing.g"

    var mid_x = global.bed_middle_x != null ? global.bed_middle_x : (move.axes[0].max - move.axes[0].min + 1) / 2
    var mid_y = global.bed_middle_y != null ? global.bed_middle_x : (move.axes[1].max - move.axes[1].min + 1) / 2
    G1 X{var.mid_x - sensors.probes[0].offsets[0]} Y{var.mid_y - sensors.probes[0].offsets[1]} F24000
    G30 P1 S-1

    var z_offset = move.axes[2].machinePosition
    G1 Z5
    echo "T1 zeroed at", var.z_offset
    G10 P1 Z{-var.z_offset}

;
; Handle any bed compensation/leveling
;

if global.use_true_bed_leveling
  G32
  G28 Z

if global.use_mesh_compensation
  G29 S1

;
; Finish up
;

if global.probe_is_klicky
  M98 P"/sys/retractprobe-forced.g"

if var.t1_probe_temp != var.t1_temp
  M568 A1 P0 R{var.t1_temp} S{var.t1_temp}
if var.t2_probe_temp != var.t2_temp
  M568 A1 P1 R{var.t2_temp} S{var.t2_temp}

if var.bed_probe_temp < var.bed_temp
   M140 S{var.bed_temp}

;
; Park the toolhead and then wait for all temperatures to be reached.
;

T-1
T0
M116 H0
M116 P0
M116 P1
