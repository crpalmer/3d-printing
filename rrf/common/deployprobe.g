if global.probe_is_klicky
  if global.probe_n_deploys > 0
    set global.probe_n_deploys = global.probe_n_deploys + 1
  else
    M98 P"/sys/deploy-klicky.g"
    set global.probe_n_deploys = 1
