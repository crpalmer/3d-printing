if global.klicky_n_deploys > 1
  set global.klicky_n_deploys = global.klicky_n_deploys - 1
  M99

if global.klicky_n_deploys == 1
  var tool = state.currentTool
  if global.klicky_is_manual == true
    T-1
	T0
    M291 S3 P"Please remove the klicky probe"
  else
    M98 P"/sys/retractprobe-automatically.g"
    echo "After retractprobe-automatically"
    M122
  
  T{var.tool}

  if sensors.probes[0].value[0] = 0
    abort "Failed to release the probe"

  set global.klicky_n_deploys = 0