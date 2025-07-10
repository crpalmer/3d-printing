if ! exists(param.S)
  abort "Missing required argument: S"

M118 P6 S{param.S} T{"alerts/"^network.hostname}

if exists(param.F)
  abort param.S