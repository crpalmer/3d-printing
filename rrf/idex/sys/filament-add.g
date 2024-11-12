var slow_speed = exists(param.S) ? param.S : 180
var fast_speed = exists(param.F) ? param.F : 300
var slow_mm = exists(param.A) ? param.A : 50
var fast_mm = exists(param.B) ? param.B : 200

if state.currentTool < 0
  abort "You need an active tool to add filament"

G4 S0
M291 S1 T55 P"Loading filament..."

M83            ; relative extrusion
G1 E{var.slow_mm} F{var.slow_speed}   ; go slow to make sure it gets loaded in there
G1 E{var.fast_mm} F{var.fast_speed}   ; push the filament into the extruder and purge the old filament