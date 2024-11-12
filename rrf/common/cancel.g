; cancel.g
; called when a print is cancelled after a pause.

if exists(global.zMax)
   if move.axes[2].homed && move.axes[2].userPosition + 5 >= global.zMax
      G1 Z{global.zMax}
   else
      G91
      G1 Z+5            ; Move the nozzle up
      G90

; Set all temperatures to 0
M140 S0               ; Turn off bed
M106 P0 S0            ; Turn off the fan
if exists(tools[1])
   M106 P2 S0         ; and the other one
   M568 A1 P0 R0 S0   ; multi-tools: set to standby
   M568 A1 P1 R0 S0
   T-1                ; and deselect the current tool
else
   M568 A2 P0 R0 S0   ; single tool: set to active


if global.print_ended_X != -123456 && move.axes[0].homed
   G1 X{global.print_ended_X} F24000

if global.print_ended_U != -123456 && move.axes[3].homed
   G1 X{global.print_ended_U} F24000

if global.print_ended_Y != -123456 && move.axes[1].homed
   G1 Y{global.print_ended_Y} F24000

if global.print_ended_Z != -123456 && move.axes[2].homed
   G1 Z{global.print_ended_Z} F24000

M18
