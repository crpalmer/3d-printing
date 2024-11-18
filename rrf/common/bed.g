T0
G1 Z5

M401

if global.bed_probe_points == null || (# global.bed_probe_points) < 1
  abort "G32 requires at least 1 point to probe"

while true
  if iterations >= 5
    abort "G32 probing failed to converge"

  var i = 0
  var is_valid_probing = true

  while var.i < (# global.bed_probe_points) - 1
    if var.is_valid_probing
      G30 P{var.i} X{global.bed_probe_points[var.i][0]} Y{global.bed_probe_points[var.i][1]} Z-99999
      if result != 0
        echo "Failed to probe [" ^ global.bed_probe_points[var.i][0] ^ ", " ^ global.bed_probe_points[var.i][1] ^ "]"
        set var.is_valid_probing = false
    set var.i = var.i + 1


  if var.is_valid_probing
    G30 P{var.i} X{global.bed_probe_points[var.i][0]} Y{global.bed_probe_points[var.i][1]} Z-99999 S{var.i+1}
    if result == 0
      echo "Pre-calibration mean error was "^ move.calibration.initial.mean ^ "mm"
      if abs(move.calibration.initial.mean) <= global.bed_probe_acceptable_stddev
        break
      else
        echo "Repeating calibration because the mean error is too high (" ^ move.calibration.initial.mean ^ "mm)"

M402
