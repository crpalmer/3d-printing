if global.probe_n_deploys > 1
  set global.probe_n_deploys = global.probe_n_deploys - 1
elif global.probe_n_deploys == 1
  if global.probe_is_klicky
    M98 P"/sys/retract-klicky.g"
  else
    M98 P"/sys/retract-bltouch.g"
