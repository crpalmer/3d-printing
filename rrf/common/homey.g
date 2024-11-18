G91                                      ; relative positioning
G1 H2 Z5 F6000                           ; lift Z relative to current position
var dist = (move.axes[1].max - move.axes[1].min + 10) * (sensors.endstops[1].highEnd ? +1 : -1)
G1 H1 Y{var.dist} F1800                  ; move quickly to X and Y axis endstops and stop there (first pass)
G1 H2 Y{var.dist < 0 ? +5 : -5} F6000    ; go back a few mm
G1 H1 Y{var.dist > 0 ? +6 : -6} F360     ; move slowly to endstops once more (second pass)
G1 H2 Z-5 F6000                          ; lower Z again
G90                                      ; absolute positioning