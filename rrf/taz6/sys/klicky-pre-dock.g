; Lift Z a little bit

G91
G1 H2 Z1 F6000
G90

if ! move.axes[2].homed
   ; Move over the button and roughly home the z axis

   M98 P"/sys/rapid-move.g" X-20 Y256
   G91
   G1 H4 Z-300 F600  ; move quickly to Z axis endstop and stop there (first pass)
   G1 H2 Z{global.klicky_pre_z - (-2.25)}    ; subtract the button height
   G90               ; absolute positioning

M98 P"/sys/rapid-move.g" X{global.klicky_pre_x} Y{global.klicky_pre_y} Z{global.klicky_pre_z}