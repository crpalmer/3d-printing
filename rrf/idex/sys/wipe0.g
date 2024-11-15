T0                          ; just in case: pick the tool
G1 X{global.xMax-1} F24000  ; and go to parked position

var fanSpeed = fans[0].requestedValue
if var.fanSpeed < 1
   M106 P0 S1
   G4 S0.5

M98 P"0:/sys/wipe-common.g" E{exists(param.E) ? param.E : 0} R{exists(param.R) ? param.R : 0} X{exists(param.X) ? param.X : 0} S{state.upTime - global.lastPurge0}

set global.lastPurge0 = state.upTime

G4 S0
M106 P0 S{var.fanSpeed}