if global.klicky_n_deploys > 1
  set global.klicky_n_deploys = global.klicky_n_deploys - 1
elif global.klicky_n_deploys == 1
  if global.klicky_is_manual == true
    M291 S3 P"Please remove the klicky probe"
  else
    M98 P"/sys/retractprobe-automatically.g"

  if sensors.probes[0].value[0] = 0
    abort "Failed to release the probe"

  set global.klicky_n_deploys = 0