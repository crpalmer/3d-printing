if move.axes[0].homed == false and move.axes[1].homed == false
  M98 P"/sys/homexy.g"
  
if move.axes[0].homed == false
  G28 X

if move.axes[1].homed == false
  G28 Y

if global.klicky_n_deploys == 0
  ;G0 X{global.klicky_pre_x} Y{global.klicky_pre_y} F24000
  ;G4 S0
  ;M280 P1 S{global.klicky_servo_up}
  ;G4 S0.5
  ;G0 X{global.klicky_dock_x} Y{global.klicky_dock_y} F1200
  ;G4 S0
  ;G0 X{global.klicky_pre_x} Y{global.klicky_pre_y} F24000
  ;G4 S0
  ;M280 P1 S{global.klicky_servo_down}
  ;G4 S0
  M291 S2 R"Insert Probe" P"Please insert the klicky probe and hit OK"
  
  if sensors.probes[0].value[0] = 1000
    abort "Failed to pick up the probe"

set global.klicky_n_deploys = global.klicky_n_deploys + 1