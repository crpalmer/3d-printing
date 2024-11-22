M98 P"/sys/homexy-if-needed.g"

if ! move.axes[2].homed
  M98 P"/sys/homez-button.g"

if move.axes[2].homed
  G1 X{global.klicky_safe_x} Y{global.klicky_safe_y} Z{global.klicky_z} F12000
  G4 S0
  M280 P0 S{global.klicky_servo_up}
  G4 S0.5
  G1 X{global.klicky_pre_x} Y{global.klicky_pre_y}
