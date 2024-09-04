if state.currentTool < 0
  abort "You need an active tool to remove filament"

M83             ; relative extrusion
G1 E10 F120     ; push out a little filament
G1 E-10 F3600    ; retract into the heatbreak

G4 S0
M291 S1 T30 P"Waiting for filament to cool before removing it all the way."

G4 S30          ; wait for the filament to cool
G1 E-200 F3600  ; remove it all the way