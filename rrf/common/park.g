if exists(tools[1])
  var tool = state.currentTool
  T-1
  T{var.tool}
else
  M98 P"/sys/rapid-move.g" X{global.park_X} Y{global.park_Y}
