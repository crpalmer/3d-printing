var base_mm = exists(param.E) ? param.E : 3
var extra_mm = exists(param.X) ? param.X : 3
var retract = exists(param.R) ? param.R : 1
var seconds = exists(param.S) ? param.S : 0
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
  
if var.prime > 0 and state.currentTool >= 0
  echo var.prime
  
  var tool = state.currentTool
  T-1  
  G1 Y3 X{global.xMax-15} U{global.uMin+15} F24000
  G1 Y-10
  if var.tool == 0
    G1 X{global.xMax-1}
  else
	G1 U{global.uMin+1}

  T{var.tool}
  G1 E{var.prime} F120
;  G1 E1 F30
  G1 E{-var.retract} F1800
  G1 Y3 F12000
  
  T-1
  if var.tool == 0
	G1 U{global.uMin+1} F24000
  else
    G1 X{global.xMax-1} F24000
  T{var.tool}