if !exists(global.in_filament_error)
  ; These variables are printer specific and must have their values defined in global-defaults.g

  ; These variables are printer specific but optional to define in global-defaults.g
  global print_ended_X = null
  global print_ended_Y = null
  global print_ended_Z = null
  global print_ended_U = null

  global bed_middle_x = null
  global bed_middle_y = null

  global bed_probe_points = []

  global park_X = null                  ; Position for pause or filament-errors
  global park_Y = null                  ; Note: not used for dual extruders

  ; Probing (klicky or bltouch)

  global probe_servo = null             ; M280 P{global.probe_servo}
  global probe_is_klicky = true

  ; Klicky configuration

  global klicky_is_manual = false

  global klicky_pre_x = null            ; Location to move to before triggering servo
  global klicky_pre_y = null
  global klicky_pre_z = null

  global klicky_servo_up = null         ; Angle to position to start deploy/retract
  global klicky_servo_down = null       ; Angle to position to end deploy/retract

  global klicky_dock_x = null           ; Position to move to after deploying servo
  global klicky_dock_y = null
  global klicky_dock_z = null

  global klicky_release_x = null        ; Final position before untriggering servo
  global klicky_release_y = null
  global klicky_release_z = null

  ; These variables are for internal use and do notneed to be defined in the global-defaults.g
  ; Instead, you must provide defaults in the else clause (here)

  global in_filament_error = false
  global probe_n_deploys = 0
  global last_wipe = { 0, 0 }
else
  set global.in_filament_error = false
  set global.probe_n_deploys = 0
  set global.last_wipe = { 0, 0 }
