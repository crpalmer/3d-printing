if global.park_X != null && global.park_Y != null
  G1 X{global.park_X} Y{global.park_Y} F24000
elif global.park_X != null
  G1 X{global.park_X} F24000
elif global.park_Y != null
  G1 Y{global.park_Y} F24000
else
  var tool = state.currentTool
  T-1
  T{var.tool}
