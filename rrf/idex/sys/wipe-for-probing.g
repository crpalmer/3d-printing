M98 P"/sys/wipe-move-to-bucket.g"
G4 P0

var y = move.axes[1].machinePosition
G1 Y22 F24000
G1 Y{var.y}
G1 Y22
G1 Y{var.y}
G1 Y22
G1 Y{var.y}
G1 Y22
G1 Y{var.y}
G1 Y22
G1 Y{var.y}
G1 Y22

M98 P"/sys/wipe-finish.g"