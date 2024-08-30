var fanSpeed = fans[2].requestedValue
M106 P2 S1

M98 P"0:/sys/wipe-common.g" E{exists(param.E) ? param.E : 0} R{exists(param.R) ? param.R : 0}  X{exists(param.X) ? param.X : 0} T1 S{state.upTime - global.lastPurge1}  F{global.T1firstUse}

set global.lastPurge1 = state.upTime
M106 P2 S{var.fanSpeed}
