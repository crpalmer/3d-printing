; Pause the print
if state.status="processing"
  set global.in_filament_error = true
  M25

; Send a notification (mqtt)
M98 P"/sys/mqtt-message.g" S"Heater fault on heater " ^ param.D

; Move out of the way and save our return position
if state.status="processing"
  G60 S2
  G91
  G1 Z+1 F6000
  G90
  M98 P"/sys/park-hotends.g"

M291 S4 R"Heater Fault" P{"Heater fault on heater " ^ param.D} S2