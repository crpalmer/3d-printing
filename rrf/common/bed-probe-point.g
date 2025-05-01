; Note: the params are all the same *EXCEPT* for P which is now I
;       (P is already used by M98 so we can't also use it here)

if ! exists(param.X) || ! exists(param.Y) || ! exists(param.K) || ! exists(param.I)
  abort "Missing required argument (one of X / Y  / K / I)"

G1 X{param.X} Y{param.Y} Z{sensors.probes[param.K].diveHeights[0]} F{sensors.probes[param.K].travelSpeed}
if exists(param.S)
  if exists(move.axes[3])
    G30 K{param.K} P{param.I} S{param.S} X{move.axes[0].machinePosition} Y{move.axes[1].machinePosition} U{move.axes[3].machinePosition} Z-99999
  else
    G30 K{param.K} P{param.I} S{param.S} X{move.axes[0].machinePosition} Y{move.axes[1].machinePosition} Z-99999
else
  if exists(move.axes[3])
    G30 K{param.K} P{param.I} X{move.axes[0].machinePosition} Y{move.axes[1].machinePosition} U{move.axes[3].machinePosition} Z-99999
  else
    G30 K{param.K} P{param.I} X{move.axes[0].machinePosition} Y{move.axes[1].machinePosition} Z-99999
