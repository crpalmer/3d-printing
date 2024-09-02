; cancel.g
; called when a print is cancelled after a pause.

set global.in_filament_error = false

if {move.axes[2].userPosition + 10 >= global.zMax}
   G1 Z{global.zMax}
else
   G91
   G1 Z+10            ; Move the nozzle up
   G90

M568 A1 P0 R0 S0      ; Turn off hotend
M140 S0               ; Turn off bed
M106 P0 S0            ; Turn off the fan

G1 X{global.xMax-1} Y{global.yMax-1} F24000

M18