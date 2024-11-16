M98 P"/sys/homexy-if-needed.g"

T0

M98 P"/sys/rapid-move.g" X{global.klicky_pre_x} Y{global.klicky_pre_y} Z{global.klicky_pre_z}

if global.probe_servo != -123456 && global.klicky_servo_up != -123456
  M280 P{global.probe_servo} S{klicky_servo_up.probe_servo_start}
  G4 S0.5

M98 P"/sys/rapid-move.g" X{global.klicky_deploy_x} Y{global.klicky_deploy_y} Z{global.klicky_deploy_z}
M98 P"/sys/rapid-move.g" X{global.klicky_pre_x} Y{global.klicky_pre_y} Z{global.klicky_pre_z}

if global.probe_servo != -123456 && global.klicky_servo_down != -123456
  M280 P{global.probe_servo} S{global.klicky_servo_down}
