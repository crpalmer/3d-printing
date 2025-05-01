var n = global.wipe_passes
if exists(param.N)
  set var.n = param.N

G4 P0
var y_mid = (global.wipe_y_range[1] - global.wipe_y_range[0])/2 + global.wipe_y_range[0]
var at_high = (move.axes[1].userPosition > var.y_mid)

var at = state.currentTool == 0 ? global.wipe_at_x : global.wipe_at_u
var range = state.currentTool == 0 ? global.wipe_x_range : global.wipe_u_range

while iterations < var.n
  var x1 = var.range != null ? var.range[0] : var.at
  var x2 = var.range != null ? var.range[1] : var.at
  var y = var.at_high ? global.wipe_y_range[0] : global.wipe_y_range[1]
  var dir = move.axes[1].userPosition > var.y ? -1 : +1

  G1 X{var.x1} Y{var.y_mid - var.dir * 4} F24000
  G1 X{var.x2} Y{var.y_mid}
  G1 X{var.x1} Y{var.y_mid + var.dir * 4}
  G1 Y{var.y}

  set var.at_high = !var.at_high

var x = move.axes[0].userPosition
if global.wipe_park_x != null
  set var.x = global.wipe_park_x

if global.wipe_park_u != null && exists(move.axes[3])
  G1 X{var.x} U{global.wipe_park_u} F24000 H2
else
  G1 X{var.x} F24000 H2
