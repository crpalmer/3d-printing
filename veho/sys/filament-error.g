set global.in_filament_error = true

; Pause the print
M25

; Move out of the way and save our return position
G60 S2
G91
G1 Z+1 F6000
G90
G1 X620 F24000

; Assume that we only have the 1 filament monitor, I'm not sure how to handle this message with multiple extruders
M291 S3 R"Unload Filament" P"Filament sensor reports: {sensors.filamentMonitors[0].status}  --  Click OKAY to unload the filament."
M98 P"/macros/filament - remove"

M291 S3 R"Load Filament" P"Prepare to load new filament"
M98 P"/macros/filament - add"

G4 S0  ; Wait for it to finish

M291 S3 R"Resume" P"Click OK to resume print or CANCEL for manual intervention."
M24