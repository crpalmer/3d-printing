var delta = 20
var speed = 12000

T0                          ; just in case: pick the tool
G1 X{global.xMax-1} F24000  ; and go to parked position
G1 Y175                     ; and over the wiping bucket
G91                         ; relative movements
;G1 X{-var.delta} F{var.speed}
;G1 X{+var.delta} F{var.speed}
G1 E10 F300                 ; 5mm/sec prime
G1 E-5 F1800                ; 30mm/sec retract
G4 S1                       ; pause to let the extruded filament harden
;G1 X{-var.delta} F{var.speed}
;G1 X{+var.delta} F{var.speed}
G90                         ; absolute movements
