if global.klicky_n_deploys > 0
  set global.klicky_n_deploys = global.klicky_n_deploys + 1
  M99

if global.klicky_is_manual == true
  G60 S3
  G1 X620 F24000
  M291 S3 P"Please attach the klicky probe"
  G1 X0 R3
else
  M98 P"/sys/deployprobe-automatically.g"

if sensors.probes[0].value[0] = 1000
  abort "Failed to pick up the probe"

set global.klicky_n_deploys = 1