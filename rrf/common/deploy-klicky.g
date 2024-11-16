var tool = state.currentTool

if global.klicky_is_manual == true
  T0
  M98 P"/sys/rapid-move.g" X{global.klicky_pre_x} Y{global.klicky_pre_y} Z{global.klicky_pre_z}
  M291 S3 P"Please attach the probe"
else
  M98 P"/sys/deploy-klicky-automatically.g"

T{var.tool}

if sensors.probes[0].value[0] != 0
  M1118.2
  abort "Failed to connect the probe"

set global.probe_n_deploys = 1
