if global.park_X != null || global.park_Y != null
  M98 P"/sys/rapid-move.g" X{global.park_X} Y{global.park_Y}
elif exists(tools[1])
  var tool = state.currentTool
  T-1
  ; TODO : need to specify homing directions
  G1 X{global.xMin + 1} U{global.uMax - 1} F24000
  T{var.tool}
else
  G1 X{global.xMin + 1} F24000
