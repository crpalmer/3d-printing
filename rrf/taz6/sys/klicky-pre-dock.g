; Lift Z a little bit

G91
G1 H2 Z1 F6000
G90

if sensors.probes[0].value[0] = 0
   ; Probe attached, use it to locate the dock

   M98 P"/sys/rapid-move.g" X10 Y10
   G30 S-1

   var lift = global.klicky_pre_z - sensors.probes[0].triggerHeight
   if var.lift <= 0
      abort "klicky_pre_z is lower than the probe trigger height!"

   echo var.lift
   G91
   G1 Z{var.lift}
   G90
   M98 P"/sys/rapid-move.g" X{global.klicky_pre_x} Y{global.klicky_pre_y}
else
   ; Probe is not attached, use the button to locate the dock

   ; Move over the button and roughly home the z axis

   M98 P"/sys/rapid-move.g" X-20 Y256
   G91
   G1 H4 Z-300 F600  ; move quickly to Z axis endstop and stop there (first pass)
   G1 H2 Z{global.klicky_pre_z - (-2.25)}    ; subtract the button height
   G90               ; absolute positioning

   M98 P"/sys/rapid-move.g" X{global.klicky_pre_x} Y{global.klicky_pre_y}