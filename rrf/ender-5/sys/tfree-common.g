var axis = param.A

if move.axes[var.axis].homed
  var x = null
  if sensors.endstops[var.axis].highEnd
    set var.x = move.axes[var.axis].max - 1
  else
    set var.x = move.axes[var.axis].min + 1
  M98 P"/sys/rapid-move.g" X{var.x}
