G91                           ; relative positioning
G1 H2 Z5 F6000                ; lift Z relative to current position

var x = (move.axes[0].max - move.axes[0].min + 10) * (sensors.endstops[0].highEnd ? +1 : -1)
var y = (move.axes[1].max - move.axes[1].min + 10) * (sensors.endstops[1].highEnd ? +1 : -1)

if exists(sensors.endstops[3])
  var u = (move.axes[3].max - move.axes[3].min + 10) * (sensors.endstops[3].highEnd ? +1 : -1)

  G1 H1 X{var.x} Y{var.y} U{var.u} F1800                                              ; move quickly to X and Y axis endstops and stop there (first pass)
  G1 H2 X{var.x < 0 ? +5 : -5} Y{var.y < 0 ? +5 : -5} U{var.u < 0 ? +5 : -5} F6000    ; go back a few mm
  G1 H1 X{var.x > 0 ? +6 : -6} Y{var.y > 0 ? +6 : -6} U{var.u > 0 ? +6 : -6} F360     ; move slowly to endstops once more (second pass)
else
  G1 H1 X{var.x} Y{var.y} F1800                                ; move quickly to X and Y axis endstops and stop there (first pass)
  G1 H2 X{var.x < 0 ? +5 : -5} Y{var.y < 0 ? +5 : -5} F6000    ; go back a few mm
  G1 H1 X{var.x > 0 ? +6 : -6} Y{var.y > 0 ? +5 : -6} F360     ; move slowly to endstops once more (second pass)

G1 H2 Z-5 F6000               ; lower Z again
G90                           ; absolute positioning