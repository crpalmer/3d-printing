; resume.g
; called before a print from SD card is resumed
var unretract = global.in_filament_error ? 1 : 3

if global.in_filament_error
   ; Wipe the tool with a retract of 1mm
   M98 P{"/sys/wipe" ^ global.filament_error_tool ^ ".g"} R1
   set global.in_filament_error = false
   set global.filament_error_tool = -1

G1 R1 X0 Y0 Z5 F24000 ; go to 5mm above position of the last print move
G1 R1 X0 Y0           ; go back to the last print move
M83                   ; relative extruder moves
G1 E{var.unretract} F1800