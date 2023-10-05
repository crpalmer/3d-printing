if global.klicky_n_deploys == 0
  abort "Probe is not deployed"

set global.klicky_n_deploys = global.klicky_n_deploys - 1

if global.klicky_n_deploys == 0
  G0 X{global.klicky_pre_x} Y{global.klicky_pre_y} F24000
  G4 S0
  M280 P1 S{global.klicky_servo_up}
  G4 S0.5
  G0 X{global.klicky_dock_x} Y{global.klicky_dock_y} F1200
  G4 S0.5
  G0 X{global.klicky_release_x} Y{global.klicky_release_y} F24000
  G4 S0
  M280 P1 S{global.klicky_servo_down}
  G4 S0
  
  if sensors.probes[0].value[0] = 0
    abort "Failed to release the probe"