var o = global.probe_block_middle
var delta = global.probe_block_diameter / 2
var from = null
var to = null

if exists(param.X) && exists(param.Y)
  abort "probe-side: Can't specify both X and Y"

if exists(param.X)
  var start_x = var.o[0] + param.X * (var.delta - 2)
  var start_y = var.o[1] + global.probe_block_directions[1] * (var.delta + 5)
  set var.from = { var.start_x, var.start_y }
  set var.to   = { var.start_x, var.o[1] }
else
  var start_x = var.o[0] + global.probe_block_directions[0] * (var.delta + 5)
  var start_y = var.o[1] + param.Y * (var.delta - 2)
  set var.from = { var.start_x, var.start_y } 
  set var.to   = { var.o[0],    var.start_y }
  
M98 P"/sys/probe-laterally.g" F{var.from} T{var.to} Z{param.Z}
