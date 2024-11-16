var tool = state.currentTool
T-1

G1 X{global.xMin+25} U{global.uMax-25} F24000 ; move beside the bucket
G1 Y{global.yMin+7} F24000              ; past the wiping bucket
G1 X{global.xMin+1} U{global.uMax-1} F24000  ; now over the bucket

T{var.tool}
