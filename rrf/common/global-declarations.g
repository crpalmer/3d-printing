if !exists(global.in_filament_error)
  ; These variables are printer specific and must have their values defined in global-defaults.g

  ; These variables are printer specific but optional to define in global-defaults.g
  global print_ended_X = -123456
  global print_ended_Y = -123456
  global print_ended_Z = -123456
  global print_ended_U = -123456

  global park_X = -123456
  global park_Y = -123456

  ; These variables are for internal use and do notneed to be defined in the global-defaults.g
  ; Instead, you must provide defaults in the else clause (here)

  global in_filament_error = false
else
  set global.in_filament_error = false
