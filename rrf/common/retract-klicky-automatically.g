var tool = state.currentTool
T0

M98 P"/sys/rapid-move.g" X{global.klicky_pre_x} Y{global.klicky_pre_y} Z{global.klicky_pre_z}

if global.probe_servo != null && global.klicky_servo_up != null
  M280 P{global.probe_servo} S{global.klicky_servo_up}
  G4 S0.5

M98 P"/sys/rapid-move.g" X{global.klicky_dock_x} Y{global.klicky_dock_y} Z{global.klicky_dock_z}
M98 P"/sys/rapid-move.g" X{global.klicky_release_x} Y{global.klicky_release_y} Z{global.klicky_release_z}

if global.probe_servo != null && global.klicky_servo_down != null
  M280 P{global.probe_servo} S{global.klicky_servo_down}

T{var.tool}
