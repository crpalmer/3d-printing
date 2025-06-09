if ! exists(tools[1])
  abort "idex-calibration failed, no second tool"

if global.probe_block_middle == null || global.probe_block_diameter == null
  abort "idex-calibration failed, no probe block defined"

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
  abort "idex-calibration failed to converge"