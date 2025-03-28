if global.probe_is_klicky
  if global.probe_n_deploys > 1
    set global.probe_n_deploys = global.probe_n_deploys - 1
  elif global.probe_n_deploys == 1
    M98 P"/sys/retract-klicky.g"
    set global.probe_n_deploys = 0
