G4 P0
var y = move.axes[1].machinePosition
G1 Y30 F24000
G1 Y{var.y}
G1 Y30
G1 Y{var.y}
G1 Y30
G4 P0

G1 X{move.axes[0].max-1} U{move.axes[3].min+1} F24000 H2