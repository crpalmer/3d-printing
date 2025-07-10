if ! exists(tools[1])
  abort "idex-calibration failed, no second tool"

if global.probe_block_middle == null || global.probe_block_diameter == null
  echo "No probe block defined, calibrating Z height at bed center"
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
else
  T0
  M98 P"/sys/wipe-for-probing.g"
  M98 P"/sys/probe-block.g"
  var p0 = global.last_probe_result
  var needs_calibration = true

  while var.needs_calibration && iterations < 5
    T1
    M98 P"/sys/wipe-for-probing.g"
    M98 P"/sys/probe-block.g"
    var p1 = global.last_probe_result
    var d_u = var.p0[0] - var.p1[0]
    var d_y = var.p0[1] - var.p1[1]
    var d_z = var.p0[2] - var.p1[2]

    if abs(var.d_u) < 0.05 && abs(var.d_y) < 0.05
      set var.needs_calibration = false
  
    echo "Current offets:", tools[1].offsets[3], ",", tools[1].offsets[1], ",", tools[1].offsets[2]
    echo "Correction:", var.d_u, ",", var.d_y, ",", var.d_z
    G10 P1 U{tools[1].offsets[3] + var.d_u} Y{tools[1].offsets[1] + var.d_y} Z{tools[1].offsets[2] + var.d_z}
    echo "New offets:", tools[1].offsets[3], ",", tools[1].offsets[1], ",", tools[1].offsets[2]

  if var.needs_calibration
    M98 P"/sys/mqtt-message.g" S"idex-calibration failed to converge" F
