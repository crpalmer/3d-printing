; This file should extrude exactly 1000mm on filament for collection.
; For 1.75mm filament that is:
;  (0.175cm/2)^2*3.14*100cm = 2.404 cm^3 
; of filament.  For filastruder PLA (1.25g/cm^3) that equates to 
;  2.404cm^3 * 1.25 g/cm^3 = 3.005g
; of filament

G28
T0               ; ***MODIFY*** if you want to test T1 for some reason ******
G1 X150 Y150 F12000
G1 Z50 F12000
M106 S0
G1 E10 F180

; When you hear the fan turn on, remove the filament that was extruded

M106 S1
G1 E-2 F18000
G4 S2
M106 S0
G1 E2 F180
G1 E500 F180
G1 E500 F180
G1 E-2 F1800

; When you hear the fan turn on, remove collect the sample

M106 S1
G1 Z75 F12000
