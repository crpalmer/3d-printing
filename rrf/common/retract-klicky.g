if sensors.probes[0].value[0] != 0
  M1118.3
  abort "Aborting -- request to release the probe when it's not attached"

if global.klicky_is_manual == true
  M98 P"/sys/rapid-move.g" X{global.klicky_pre_x} Y{global.klicky_pre_y} Z{global.klicky_pre_z}
  M291 S3 P"Please remove the probe"
else
  M98 P"/sys/retract-klicky-automatically.g"

if sensors.probes[0].value[0] != 1000
  M1118.3
  abort "Failed to release the probe"
