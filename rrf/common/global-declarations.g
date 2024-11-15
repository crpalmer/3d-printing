if !exists(global.in_filament_error)
  ; These variables are printer specific and must have their values defined in global-defaults.g

  ; These variables are printer specific but optional to define in global-defaults.g
  global print_ended_X = -123456
  global print_ended_Y = -123456
  global print_ended_Z = -123456
  global print_ended_U = -123456

  global park_X = -123456
  global park_Y = -123456

  ; Probing (klicky or bltouch)

  global probe_is_manual = false
  global probe_is_connected_value = -123456
  global probe_not_connected_value = -123456

  global probe_pre_x = -123456             ; Location to move to before triggering servo
  global probe_pre_y = -123456
  global probe_pre_z = -123456

  global probe_servo = -123456		   ; M280 P{global.probe_servo}
  global probe_servo_start = -123456       ; Angle to position to start deploy/retract
  global probe_servo_deploy_done = -123456 ; Angle to position to end deploy
  global probe_servo_retract_done = -123456 ; angle to finish retract

  global probe_deploy_x = -123456          ; Position to move to after deploying servo
  global probe_deploy_y = -123456
  global probe_deploy_z = -123456

  global probe_release_x = -123456         ; Final position before untriggering servo
  global probe_release_y = -123456
  global probe_release_z = -123456

  ; These variables are for internal use and do notneed to be defined in the global-defaults.g
  ; Instead, you must provide defaults in the else clause (here)

  global in_filament_error = false
  global probe_n_deploys = 0
else
  set global.in_filament_error = false
  set global.probe_n_deploys = 0
