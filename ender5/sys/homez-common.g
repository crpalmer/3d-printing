var tool = state.currentTool

T0

G91
G1 H2 Z5 F6000    ; lift Z relative to current position
G90
; Probe at the middle of the plate (but offset 20mm toward the back to avoid the middle magnet)
G1 X{(global.brX - global.blX) / 2 + global.blX - global.blTouchX} Y{(global.frontY - global.blrY) / 2 + global.blrY - global.blTouchY + 20} F24000
G4 P100
G30

T{var.tool}