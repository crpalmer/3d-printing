; pause.g
; called when a print from SD card is paused

if ! global.in_filament_error
   M83            ; relative extruder moves
   G1 E-3 F1800   ; retract 3mm of filament
   G91            ; relative positioning
   G1 Z5 F360     ; lift Z by 5mm
   G90            ; absolute positioning
   M98 P"/sys/rapid-move.g" X{global.pause_x} Y{global.pause_y}
