; bed.g
; called to perform automatic bed compensation via G32

; Probe front right
G1 Z2
G1 X305 Y0 F12000
G30 P0 Z-99999

; Probe front left
G1 X75 Y0 F12000
G4 P100
G30 P1 Z-99999

; Probe back left
G1 X75 Y380 F12000
G4 P100
G30 P2 Z-99999

; Probe back right
G1 X305 Y380 F12000
G4 P100
G30 P3 Z-99999 S4
