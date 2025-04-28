if ! exists(sensors.probes[state.currentTool])
  T0
var probe = state.currentTool

G1 Z5

if global.probe_is_klicky
  M401

if global.bed_probe_points == null || (# global.bed_probe_points) < 1
  abort "G32 requires at least 1 point to probe"

while true
  if iterations >= 5
    abort "G32 probing failed to converge"

  var is_valid_probing = true

  while iterations < (# global.bed_probe_points)-1
    if var.is_valid_probing
      echo "G30 K"^var.probe^" P"^iterations^" X"^global.bed_probe_points[iterations][0]^" Y"^global.bed_probe_points[iterations][1]^" Z-99999"
      G30 K{var.probe} P{iterations} X{global.bed_probe_points[iterations][0]} Y{global.bed_probe_points[iterations][1]} Z-99999
      if result != 0
        echo "Failed to probe [" ^ global.bed_probe_points[iterations][0] ^ ", " ^ global.bed_probe_points[iterations][1] ^ "]"
        set var.is_valid_probing = false
      else
        echo "Probe", global.bed_probe_points[iterations][0], ",", global.bed_probe_points[iterations][1], "@", sensors.probes[0].lastStopHeight

  if var.is_valid_probing
    var i = #global.bed_probe_points - 1
    G30 K{var.probe} P{var.i} X{global.bed_probe_points[var.i][0]} Y{global.bed_probe_points[var.i][1]} Z-99999 S{var.i+1}
    if result == 0
      echo "Probe", global.bed_probe_points[var.i][0], ",", global.bed_probe_points[var.i][1], "@", sensors.probes[0].lastStopHeight
      echo "Mean error:", move.calibration.initial.mean, "stddev:", move.calibration.initial.deviation
      if abs(move.calibration.initial.deviation) <= global.bed_meshing_max_stddev
        break
      else
        echo "Repeating calibration because the stddev is too high (" ^ move.calibration.initial.deviation ^ "mm)"

if global.probe_is_klicky
  M402