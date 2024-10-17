if global.klicky_n_deploys > 0
  set global.klicky_n_deploys = global.klicky_n_deploys + 1
else
  var tool = state.currentTool

  if global.klicky_is_manual == true
    T-1
    T0
    M291 S3 P"Please attach the klicky probe"
  else
    M98 P"/sys/deployprobe-automatically.g"

  T{var.tool}

  if sensors.probes[0].value[0] = 1000
    abort "Failed to pick up the probe"

  set global.klicky_n_deploys = 1