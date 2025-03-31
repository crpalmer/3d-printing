;var x = global.probe_pin_x
;var y = global.probe_pin_y
;var z = global.probe_pin_z
;var d = global.probe_pin_d

var x = 259
var y = -5.35
var z = 0.8
var d = 4

G1 Z{var.z+5} F24000
G1 X{var.x} Y{var.y}

; Probe x from the left
G1 Z{var.z+5}
G1 X{var.x - var.d/2 - 2} Y{var.y}
G1 Z{var.z}
G38.2 X{var.x}
var last_pin_x0 = move.axes[0].machinePosition
G1 X{var.x - var.d/2 - 2} Y{var.y}

; Probe x from the right
G1 Z{var.z+5}
G1 X{var.x + var.d/2 + 2} Y{var.y}
G1 Z{var.z}
G38.2 X{var.x}
var last_pin_x1 = move.axes[0].machinePosition
G1 X{var.x + var.d/2 + 2} Y{var.y}

var last_pin_x = var.last_pin_x0 + (var.last_pin_x1 - var.last_pin_x0) / 2

; Probe y from the front
G1 Z{var.z+5}
G1 X{var.x} Y{var.y - var.d/2 - 2}
G1 Z{var.z}
G38.2 Y{var.y}
var last_pin_y0 = move.axes[1].machinePosition
G1 X{var.x} Y{var.y - var.d/2 - 2}

; Probe y from the back
G1 Z{var.z+5}
G1 X{var.x} Y{var.y + var.d/2 + 2}
G1 Z{var.z}
G38.2 Y{var.y}
var last_pin_y1 = move.axes[1].machinePosition
G1 X{var.x} Y{var.y + var.d/2 + 2}

var last_pin_y = var.last_pin_y0 + (var.last_pin_y1 - var.last_pin_y0) / 2

G1 Z{var.z + 5}
echo "pin @ "^ var.last_pin_x ^"["^ var.last_pin_x0 ^".."^ var.last_pin_x1 ^"], "^var.last_pin_y ^"["^ var.last_pin_y0 ^".."^ var.last_pin_y1 ^"]"