M98 P"0:/sys/wipe-common.g" E{exists(param.E) ? param.E : 0} R{exists(param.R) ? param.R : 0} X{exists(param.X) ? param.X : 0} T0 S{state.upTime - global.lastPurge0}
set global.lastPurge0 = state.upTime
