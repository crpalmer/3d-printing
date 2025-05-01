if !exists(global.in_filament_error)
  ; These variables are printer specific and must have their values defined in global-defaults.g

  ; These variables are printer specific but optional to define in global-defaults.g
  global print_ended_x = null
  global print_ended_y = null
  global print_ended_z = null
  global print_ended_u = null

  global pause_x = null
  global pause_y = null

  global bed_middle_x = null
  global bed_middle_y = null

  global bed_probe_points = null
  global bed_meshing_max_stddev = 0.02

  ; Probing (klicky or nozzle based probe)

  global probe_servo = null             ; M280 P{global.probe_servo}
  global probe_is_klicky = true
  global probe_at_temperature_delta = null

  ; Probing to find a corner of a fixed block (IDEX calibration)
  global probe_block_middle = null
  global probe_block_diameter = null
  global probe_block_directions = { -1, +1 }

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

  ; Configuration of print startup
  global use_mesh_compensation = false
  global use_true_bed_leveling = true
  
  ; Wiping configuration
  global wipe_passes = 3
  global wipe_for_probing_passes = 7
  global wipe_x_range = null
  global wipe_u_range = null
  global wipe_y_range = null
  global wipe_park_x = null
  global wipe_park_u = null
  global wipe_safe_x = null
  global wipe_safe_u = null
  global wipe_at_x = null
  global wipe_at_u = null
  global wipe_at_y = null

  ; These variables are for internal use and do notneed to be defined in the global-defaults.g
  ; Instead, you must provide defaults in the else clause (here)

  global in_filament_error = false
  global probe_n_deploys = 0
  global last_wipe = { 0, 0 }
  global last_probe_result = {0, 0}
else
  set global.in_filament_error = false
  set global.probe_n_deploys = 0
  set global.last_wipe = { 0, 0 }
