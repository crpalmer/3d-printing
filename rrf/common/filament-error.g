set global.in_filament_error = true

; Pause the print
M25

; Send a notification (mqtt)
M1118.1

; Move out of the way and save our return position
G60 S2
G91
G1 Z+1 F6000
G90
M98 P{"/sys/tfree" ^ state.currentTool ^ ".g"}

G4 S0
M291 S3 R"Unload Filament" P{"Filament sensor for tool " ^ state.currentTool ^ " reports: " ^ sensors.filamentMonitors[state.currentTool].status ^ "  --  Click OKAY to unload the filament."}
M98 P"/sys/filament-remove.g"

G4 S0
M291 S3 R"Load Filament" P{"Prepare to load new filament for tool " ^ state.currentTool}
M98 P"/sys/filament-add.g" A50 B50

G4 S0
M291 S3 R"Resume" P"Click OK to resume print or CANCEL for manual intervention."
M24
