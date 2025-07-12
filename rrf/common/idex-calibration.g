if ! exists(tools[1])
  abort "idex-calibration failed, no second tool"

echo "Calibrating Z height at bed center"

var tool = state.currentTool
T1

var mid_x = global.bed_middle_x != null ? global.bed_middle_x : (move.axes[0].max - move.axes[0].min + 1) / 2
var mid_y = global.bed_middle_y != null ? global.bed_middle_y : (move.axes[1].max - move.axes[1].min + 1) / 2

while iterations < 10
  M98 P"/sys/wipe-for-probing.g"
  var p = {0, 0}
  while iterations < 2
    G1 Z5
    G1 X{var.mid_x - sensors.probes[state.currentTool].offsets[0]} Y{var.mid_y - sensors.probes[state.currentTool].offsets[1]} F24000
    G30 K{state.currentTool} S-1
    set var.p[iterations] = move.axes[2].userPosition
  if abs(var.p[0] - var.p[1]) < 0.05
    G10 P1 Z{tools[1].offsets[2] - (var.p[0]+var.p[1])/2}
    G1 Z5
    break
  else
    echo "Failed to probe Z, retrying."
if state.currentTool != var.tool
  T{var.tool}