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

if global.wipe_park_u != null && exists(move.axes[3])
  G1 X{var.x} U{global.wipe_park_u} F24000 H2
else
  G1 X{var.x} F24000 H2