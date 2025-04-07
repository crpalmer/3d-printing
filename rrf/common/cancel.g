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

M98 P"/sys/rapid-move.g" X{global.print_ended_x} Y{global.print_ended_y} U{global.print_ended_u} Z{global.print_ended_z}
M18