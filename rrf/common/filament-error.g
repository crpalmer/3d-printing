set global.in_filament_error = true

; Pause the print
M25

; Send a notification (mqtt)
M98 P"/sys/mqtt-message.g" S"Filament runout sensor triggered"

; Temporarily disabe the runout sensor
M591 D{state.currentTool} S0

; Move out of the way and save our return position
G60 S2
G91
G1 Z+1 F6000
G90
M98 P"/sys/park-hotends.g"

while true
  G4 S0
  M291 S4 R"Filament" P{"Filament sensor for tool " ^ state.currentTool ^ " reports an issue."} K{"Unload Filament", "Load Filament", "Resume", "Manual Intervention"}
  if input == 0
    M98 P"/sys/filament-remove.g"
  elif input == 1
    M98 P"/sys/filament-add.g" A50 B50
  elif input == 2
    M24
    break
  elif input == 3
    break
  else
    abort "Unexpected input value: " ^ input