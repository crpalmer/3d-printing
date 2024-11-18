var fan_speed = 1

if exists(tools[state.currentTool].fans[0])
  set var.fan_speed = fans[tools[state.currentTool].fans[0]].requestedValue

if var.fan_speed < 1
   M106 S1
   G4 S0.5

var base_mm = exists(param.E) ? param.E : 3
var extra_mm = exists(param.X) ? param.X : 3
var retract = exists(param.R) ? param.R : 1
var seconds = state.upTime - global.last_wipe[state.currentTool]
var min_mm = exists(param.M) ? param.M : 10

var multiplier = 0
if var.seconds > 480
  set var.multiplier = 3
elif var.seconds > 120
   set var.multiplier = 2
elif var.seconds > 10
     set var.multiplier = 1

var prime = var.base_mm + var.multiplier*var.extra_mm
if var.prime < var.min_mm
  set var.prime = var.min_mm
  
if var.prime > 0
  M98 P"/sys/wipe-move-to-bucket.g"
  G1 E{var.prime} F120
  G1 E{-var.retract} F1800
  G1 Y3 F12000
  M98 P"/sys/wipe-finish.g"

G4 S0
set global.last_wipe[state.currentTool] = state.upTime

if var.fan_speed < 1
  M106 S{var.fan_speed}