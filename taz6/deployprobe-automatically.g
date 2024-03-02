M98 P"/sys/klicky-pre-dock.g"

G0 X{global.klicky_dock_x} Y{global.klicky_dock_y} F1200
G0 X{global.klicky_pre_x} Y{global.klicky_pre_y} F24000
G0 X{global.klicky_pre_x + 50}
G4 S0
M280 P0 S{global.klicky_servo_down}
G4 S0.5