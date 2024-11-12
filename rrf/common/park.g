if global.park_X != -123456 and global.park_Y != -123456
  G1 X{global.park_X} Y{global.park_Y} F24000
else if global.park_X != -123456
  G1 X{global.park_X} F24000
else if global.park_Y != -123456
  G1 Y{global.park_Y} F24000
else
  var tool = state.currentTool
  T-1
  T{var.tool}
