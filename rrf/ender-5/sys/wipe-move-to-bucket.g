var tool = state.currentTool
T-1

G1 X{move.axes[0].min+25} U{move.axes[3].max-25} F24000 ; move beside the bucket
G1 Y{move.axes[1].min+7} F24000              ; past the wiping bucket
G1 X{move.axes[0].min+1} U{move.axes[3].max-1} F24000  ; now over the bucket

T{var.tool}
