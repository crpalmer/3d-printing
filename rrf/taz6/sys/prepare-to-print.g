if ! exists(param.H) || ! exists(param.B)
  echo "Missing required parameter (H and B)"
  M99

var bed_temp = param.B
var probing_temp = min(var.bed_temp, 60)

M220 S100     ; clear any speed changes
M290 R0 S0    ; clear any baby stepping
M106 S0       ; disable fans

M104 S{param.H}
M190 R{var.probing_temp}    ; Wait to get up (or down!) to the right temperature

M561
M98 P"/sys/homexy.g"
M98 P"/sys/homez-button.g"
M401
G28 Z
M98 P"/sys/retractprobe-forced.g"

if var.probing_temp < var.bed_temp
   M140 S{var.bed_temp}

M116