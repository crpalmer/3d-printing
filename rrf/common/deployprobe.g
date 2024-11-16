if global.probe_n_deploys > 0
  set global.probe_n_deploys = global.probe_n_deploys + 1
else
  if global.probe_is_klicky
    M98 P"/sys/deploy-klicky.g"
  else
    M98 P"/sys/deploy-bltouch.g"

  set global.probe_n_deploys = 1
