var from = param.F
var target = param.T
var z = param.Z

G1 Z{var.z+5} F24000
G1 X{var.from[0]} Y{var.from[1]}
G1 Z{var.z}

G38.2 X{var.target[0]} Y{var.target[1]} K{state.currentTool}

if result != 0
   abort "Probing failed"

set global.last_probe_result = { move.axes[state.currentTool == 1 ? 3 : 0].machinePosition, move.axes[1].machinePosition }

G1 X{var.from[0]} {var.from[1]} F24000
G1 Z{var.z+5}

echo "probe-pin-once: ", global.last_probe_result