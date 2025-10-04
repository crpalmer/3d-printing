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

  ; Probing

  global probe_at_temperature_delta = null
  global probe_extra_squish = 0

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
  global last_wipe = { 0, 0 }
  global last_probe_failed = false
  global last_probe_result = {0, 0}
  global last_homez_failed = false
else
  set global.in_filament_error = false
  set global.last_wipe = { 0, 0 }
  set global.last_probe_failed = false
  set global.last_homez_failed = false
