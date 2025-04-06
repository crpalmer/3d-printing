var x = move.axes[0].machinePosition
var u = null

if global.wipe_safe_x != null
  set var.x = global.wipe_safe_x
elif global.wipe_park_x != null
  set var.x = global.wipe_park_x

if global.wipe_safe_u != null
  set var.u = global.wipe_safe_u
elif global.wipe_park_u != null
  set var.u = global.wipe_park_u

if var.u != null
  G1 X{var.x} U{var.u} F24000 H2 ; move beside the bucket
else
  G1 X{var.x} F24000 H2 ; move beside the bucket

if global.wipe_at_y != null
  G1 Y{global.wipe_at_y} F24000              ; past the wiping bucket
elif global.wipe_y_range != null
  var mid = (global.wipe_y_range[1] - global.wipe_y_range[0])/2 + global.wipe_y_range[0]
  G4 P0
  if move.axes[1].machinePosition > var.mid
    G1 Y{global.wipe_y_range[1]} F24000
  else
    G1 Y{global.wipe_y_range[0]} F24000

; Move just the wiping tool in line with the bucket
if state.currentTool == 0 and global.wipe_at_x != null
  G1 X{global.wipe_at_x} H2
elif state.currentTool == 1 and global.wipe_at_u != null
  G1 U{global.wipe_at_u} H2
