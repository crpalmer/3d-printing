M98 P"0:/sys/wipe-common.g" E{exists(param.E) ? param.E : 0} R{exists(param.R) ? param.R : 0}  X{exists(param.X) ? param.X : 0} T1 S{state.upTime - global.lastPurge1}
set global.lastPurge1 = state.upTime
