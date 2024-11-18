var tool = state.currentTool
T-1

G1 X{move.axes[0].max-15} U{move.axes[3].min+15} F24000 ; move beside the bucket
G1 Y-10 F24000              ; past the wiping bucket

; Move just the wiping tool in line with the bucket
if var.tool == 0
  G1 X{move.axes[0].max-1}
else
  G1 U{move.axes[3].min+1}

T{var.tool}