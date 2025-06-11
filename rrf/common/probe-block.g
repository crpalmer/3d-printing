var cur = { 0, 0, 0 }
var converged = false

while iterations < 5 && ! var.converged
  G1 Z5 F24000
  G1 X{global.probe_block_middle[0]} Y{global.probe_block_middle[1]} Z{global.probe_block_middle[2]}
  G4 S1
  G30 S-1 K{state.currentTool}
  var z0 = move.axes[2].userPosition
  var z = var.z0 - 0.15

  echo "probe-find-corner: using Z =", var.z

  M98 P"/sys/probe-side.g" Y+1 Z{var.z}
  var x1 = global.last_probe_result[0]
  M98 P"/sys/probe-side.g" Y-1 Z{var.z}
  var x2 = global.last_probe_result[0]

  M98 P"/sys/probe-side.g" X-1 Z{var.z}
  var y1 = global.last_probe_result[1]
  M98 P"/sys/probe-side.g" X+1 Z{var.z}
  var y2 = global.last_probe_result[1]

  var next = { var.x1 + (var.x2 - var.x1)/2, var.y1 + (var.y2 - var.y1)/2, var.z0 }

  if abs(var.next[0] - var.cur[0]) < 0.05 && abs(var.next[1] - var.cur[1]) < 0.05 && abs(var.next[2] - var.cur[2]) < 0.05
    set var.converged = true
    echo "probe-block: converged:", var.next
  else
    echo "probe-block: not yet converged:", var.next
  set var.cur = var.next

if ! var.converged
  abort "probe-block: failed to converge"
  
set global.last_probe_result = var.cur
echo "probe-block:", global.last_probe_result