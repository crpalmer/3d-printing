T0

M98 P"/sys/rapid-move.g" X{global.probe_pre_x} Y{global.probe_pre_y} Z{global.probe_pre_z}

if global.probe_servo != -123456 && global.probe_servo_start != -123456
  M280 P{global.probe_servo} S{global.probe_servo_start}
  G4 S0.5

M98 P"/sys/rapid-move.g" X{global.probe_deploy_x} Y{global.probe_deploy_y} Z{global.probe_deploy_z}
M98 P"/sys/rapid-move.g" X{global.probe_release_x} Y{global.probe_release_y} Z{global.probe_release_z}

if global.probe_servo != -123456 && global.probe_servo_retract_done != -123456
  M280 P{global.probe_servo} S{global.probe_servo_retract_done}