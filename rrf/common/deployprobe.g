if global.probe_n_deploys > 0
  set global.probe_n_deploys = global.probe_n_deploys + 1
  M99

var tool = state.currentTool

if global.probe_is_manual == true
  T-1
  T0
  M291 S3 P"Please attach the probe"
else
  M98 P"/sys/deployprobe-automatically.g"

T{var.tool}

if global.probe_not_connected_value != -123456 && sensors.probes[0].value[0] = global.probe_not_connected_value
  M1118.2
  abort "Failed to connect the probe"

set global.probe_n_deploys = 1
