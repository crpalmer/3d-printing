if state.currentTool < 0
  abort "You must have an active tool to probe the pin"

if ! exists(sensors.probes[state.currentTool])
  abort "Tool "^ state.currentTool ^" does not have a probe associated with it"

var x = global.probe_pin_location[0]
var y = global.probe_pin_location[1]
var z = global.probe_pin_location[2]
var d = global.probe_pin_diameter

var delta = var.d/2 + 2

M98 P"/sys/probe-pin-once.g" F{{var.x - var.delta, var.y}} T{{var.x + var.d/2, var.y}} Z{var.z}
var x0 = global.last_probe_result[0]
M98 P"/sys/probe-pin-once.g" F{{var.x + var.delta, var.y}} T{{var.x - var.d/2, var.y}} Z{var.z}
var x1 = global.last_probe_result[0]
M98 P"/sys/probe-pin-once.g" F{{var.x, var.y - var.delta}} T{{var.x, var.y + var.d/2}} Z{var.z}
var y0 = global.last_probe_result[1]
M98 P"/sys/probe-pin-once.g" F{{var.x, var.y + var.delta}} T{{var.x, var.y - var.d/2}} Z{var.z}
var y1 = global.last_probe_result[1]

set global.last_probe_result = {var.x0 + (var.x1 - var.x0) / 2, var.y0 + (var.y1 - var.y0) / 2}
echo "pin-probe result:", global.last_probe_result