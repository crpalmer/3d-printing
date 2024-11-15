if global.probe_n_deploys > 1
  set global.probe_n_deploys = global.probe_n_deploys - 1
elif global.probe_n_deploys == 1
  var tool = state.currentTool
  if global.probe_is_manual == true
    T-1
    T0
    M291 S3 P"Please remove the probe"
  else
    M98 P"/sys/retractprobe-automatically.g"
  T{var.tool}

  if global.probe_is_connected_value != -123456 && sensors.probes[0].value[0] == global.probe_is_connected_value
    M1118.3
    abort "Failed to release the probe"

  set global.probe_n_deploys = 0
