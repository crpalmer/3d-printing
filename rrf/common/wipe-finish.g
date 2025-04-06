var n = global.wipe_passes
if exists(param.N)
  set var.n = param.N

G4 P0
var at_high = (move.axes[1].machinePosition > (global.wipe_y_range[1] - global.wipe_y_range[0])/2 + global.wipe_y_range[0])

while iterations < var.n
  if var.at_high
    G1 Y{global.wipe_y_range[0]} F24000
  else
    G1 Y{global.wipe_y_range[1]} F24000
  set var.at_high = !var.at_high

var x = move.axes[0].machinePosition
if global.wipe_park_x != null
  set var.x = global.wipe_park_x

var u = move.axes[3].machinePosition
if global.wipe_park_u != null
  set var.u = global.wipe_park_u

G1 X{var.x} U{var.u} F24000 H2