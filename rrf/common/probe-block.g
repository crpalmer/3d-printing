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

set global.last_probe_result = { var.x1 + (var.x2 - var.x1)/2, var.y1 + (var.y2 - var.y1)/2, var.z0 }
echo "probe-block:", global.last_probe_result