; resume.g
; called before a print from SD card is resumed

if global.in_filament_error
   M98 P"/sys/wipe.g"

   ; Go back to where our safe pre-position and unretract
   G1 R2 X0 Y0 Z1 F24000
   G1 R2 Z0
   G1 E1 F1800

   set global.in_filament_error = false
else
   G1 R1 X0 Y0 Z5 F6000 ; go to 5mm above position of the last print move
   G1 R1 X0 Y0          ; go back to the last print move
   M83                  ; relative extruder moves
   G1 E3 F1800          ; extrude 3mm of filament

