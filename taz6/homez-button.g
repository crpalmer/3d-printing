if sensors.probes[0].value[0] = 0
   abort "Cannot probe the Z min button when the probe is attached."

M98 P"/sys/homexy-if-needed.g"

G91               ; relative positioning
G1 H2 Z5 F6000    ; lift Z relative to current position
G90

G1 X-20 Y256 F12000

G91
G1 H4 Z-300 F600  ; move quickly to Z axis endstop and stop there (first pass)
G1 H2 Z2 F200     ; go back a few mm
G1 H4 Z-4 F30     ; move slowly to Z axis endstop once more (second pass)
G90               ; absolute positioning

G92 Z-1.5         ; set Z zero approximately based on where the bed is
G1 Z5 F12000