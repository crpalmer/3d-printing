var x = exists(param.X) && move.axes[0].homed ? param.X : -123456
var y = exists(param.Y) && move.axes[1].homed ? param.Y : -123456
var u = exists(param.U) && move.axes[3].homed ? param.U : -123456
var z = exists(param.Z) && move.axes[2].homed ? param.Z : -123456

var rate = 24000

; echo "rapid move requested to "^ (exists(param.X) ? param.X : "n/a") ^", "^ (exists(param.Y) ? param.Y : "n/a") ^", "^ (exists(param.U) ? param.U : "n/a") ^", "^ (exists(param.Z) ? param.Z : "n/a")
; echo "rapid move to "^ var.x ^", "^ var.y ^", "^ var.u ^", "^ var.z

if var.x != -123456 && var.y != -123456 && var.u != -123456 && var.z != -123456
  G1 X{var.x} Y{var.y} Y{var.u} Z{var.z} F{var.rate}
elif var.x != -123456 && var.y != -123456 && var.u != -123456
  G1 X{var.x} Y{var.y} U{var.u} F{var.rate}
elif var.x != -123456  && var.y != -123456 && var.z != -123456
  G1 X{var.x} Y{var.y} Z{var.z} F{var.rate}
elif var.x != -123456 && var.y != -123456
  G1 X{var.x} Y{var.y} F{var.rate}
else
  if var.x != -123456
     G1 X{var.x} F{var.rate}
  if var.y != -123456
     G1 Y{var.y} F{var.rate}
  if var.u != -123456
     G1 U{var.y} F{var.rate}
  if var.z != -123456
     G1 Z{var.z} F{var.rate}

G4 S0