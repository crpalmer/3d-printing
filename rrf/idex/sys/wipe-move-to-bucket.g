G1 X{move.axes[0].max-15} U{move.axes[3].min+15} F24000 H2 ; move beside the bucket
G1 Y-10 F24000              ; past the wiping bucket

; Move just the wiping tool in line with the bucket
if state.currentTool == 0
  G1 X{move.axes[0].max-5} H2
else
  G1 U{move.axes[3].min+5} H2