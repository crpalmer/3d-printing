var bed_temp = null

if exists(tools[1])
  if exists(param.H) == false or exists(param.I) == false or exists(param.B) == false or exists(param.C) == false
    echo "Missing required parameter (H/I and B/C)"
    M99
  M568 A1 P0 R{param.H} S{param.H}
  M568 A1 P1 R{param.I} S{param.I}
  set var.bed_temp = max(param.B, param.C)
else
  if exists(param.H) == false or exists(param.B) == false
    echo "Missing required parameter (H and B)"
    M99
  M568 A2 P0 R{param.H} S{param.H}
  set var.bed_temp = param.B

var probing_temp = min(var.bed_temp, 60)

M220 S100     ; clear any speed changes
M290 R0 S0    ; clear any baby stepping
M106 S0       ; disable fans

set global.last_wipe = { 0, 0 }

M190 R{var.probing_temp}    ; Wait to get up (or down!) to the right temperature

M561

if global.probe_is_klicky
  M98 P"/sys/homexy.g"
  T0
  M401
  G28 Z
else
  G28

G32
G28 Z

if global.probe_is_klicky
  M98 P"/sys/retractprobe-forced.g"

M98 P{"/sys/tfree " ^ state.currentTool ^ ".g"}

if var.probing_temp < var.bed_temp
   M140 S{var.bed_temp}

M116
