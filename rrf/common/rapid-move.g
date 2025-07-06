var x = exists(param.X) && move.axes[0].homed ? param.X : null
var y = exists(param.Y) && move.axes[1].homed ? param.Y : null
var u = exists(param.U) && exists(move.axes[3]) && move.axes[3].homed ? param.U : null
var z = exists(param.Z) && move.axes[2].homed ? param.Z : null

var rate = 24000

; echo "rapid move requested to "^ (exists(param.X) ? param.X : "n/a") ^", "^ (exists(param.Y) ? param.Y : "n/a") ^", "^ (exists(param.U) ? param.U : "n/a") ^", "^ (exists(param.Z) ? param.Z : "n/a")
; echo "rapid move to "^ var.x ^", "^ var.y ^", "^ var.u ^", "^ var.z

if var.x != null && var.y != null && var.u != null && var.z != null
  G1 X{var.x} Y{var.y} Y{var.u} Z{var.z} F{var.rate}
elif var.x != null && var.y != null && var.u != null
  G1 X{var.x} Y{var.y} U{var.u} F{var.rate}
elif var.x != null  && var.y != null && var.z != null
  G1 X{var.x} Y{var.y} Z{var.z} F{var.rate}
elif var.x != null && var.y != null
  G1 X{var.x} Y{var.y} F{var.rate}
else
  if var.x != null
     G1 X{var.x} F{var.rate}
  if var.y != null
     G1 Y{var.y} F{var.rate}
  if var.u != null
     G1 U{var.y} F{var.rate}
  if var.z != null
     G1 Z{var.z} F{var.rate}

G4 S0
