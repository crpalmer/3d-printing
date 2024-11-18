var tool = state.currentTool
T-1

G1 Y3 F24000
G1 X{move.axes[0].max-1} U{move.axes[3].min+1} F24000

T{var.tool}