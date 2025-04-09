var tool = state.currentTool
if global.probe_is_klicky
  T0
elif var.tool != 0 && ! exists(sensors.probes[var.tool])
  T0

G91
G1 H2 Z5 F6000    ; lift Z relative to current position
G90

if global.probe_is_klicky
  M401

var mid_x = global.bed_middle_x != null ? global.bed_middle_x : (move.axes[0].max - move.axes[0].min + 1) / 2
var mid_y = global.bed_middle_y != null ? global.bed_middle_y : (move.axes[1].max - move.axes[1].min + 1) / 2
G1 X{var.mid_x - sensors.probes[0].offsets[0]} Y{var.mid_y - sensors.probes[0].offsets[1]} F24000
G30 K{state.currentTool}

if global.probe_is_klicky
  M402

;if state.currentTool != var.tool
T{var.tool}
