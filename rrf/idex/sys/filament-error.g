set global.in_filament_error = true
set global.filament_error_tool = state.currentTool

; Pause the print
M25

; Move out of the way and save our return position
;G60 S2
;G91
;G1 Z+1 F6000

T-1
T{global.filament_error_tool}

G4 S0
M291 S3 R"Unload Filament" P{"Filament sensor for tool " ^ global.filament_error_tool ^ " reports: " ^ sensors.filamentMonitors[global.filament_error_tool].status ^ "  --  Click OKAY to unload the filament."}
M98 P"/sys/filament-remove.g"

G4 S0
M291 S3 R"Load Filament" P{"Prepare to load new filament for tool " ^ global.filament_error_tool}
M98 P"/sys/filament-add.g" A50 B50

G4 S0
M291 S3 R"Resume" P"Click OK to resume print or CANCEL for manual intervention."
M24