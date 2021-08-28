T0                          ; just in case: pick the tool
G1 X{global.xMax-1} F24000  ; and go to parked position
G1 Y175                     ; and over the wiping bucket
G1 E10 F300                 ; 5mm/sec prime
G1 E-5 F1800                ; 30mm/sec retract
G4 S1                       ; pause to let the extruded filament harden