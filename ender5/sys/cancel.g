; cancel.g
; called when a print is cancelled after a pause.

if {move.axes[2].userPosition + 10 >= global.zMax}
   G1 Z{global.zMax}
else
   G91
   G1 Z+10            ; Move the nozzle up
   G90

; Set all temperatures to 0
M568 A1 P0 R0 S0
M568 A1 P1 R0 S0
if global.includeDuplication > 0
  M568 A1 P2 R0 S0
M140 S0            ; Turn off bed

M106 P0 S0            ; Turn off the fan
M106 P2 S0            ; and the other one

; Move the tools out of the way
T-1
G1 X{global.xMin+1} U{global.uMax-1} Y225 F24000

G1 Z5              ; bring the bed up for easy print removal and faster next print

M18