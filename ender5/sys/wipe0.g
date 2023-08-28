var fanSpeed = fans[0].requestedValue
M106 P0 S1

M98 P"0:/sys/wipe-common.g" E{exists(param.E) ? param.E : 0} R{exists(param.R) ? param.R : 0} X{exists(param.X) ? param.X : 0} T0 S{state.upTime - global.lastPurge0} F{global.T0firstUse}

set global.lastPurge0 = state.upTime
M106 P0 S{var.fanSpeed}