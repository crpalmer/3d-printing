if sensors.probes[0].value[0] = 0
   abort "Cannot probe the Z min button when the probe is attached."

; Lift Z a little bit

G91
G1 H2 Z5 F6000
G90

; Move over the button

G1 X-20 Y256 F12000

; Use the bottom to position z at the height of the dock.  This does
; not change (or even set if the axis is unhomed) the current z zero.

G91
G1 H4 Z-300 F600  ; move quickly to Z axis endstop and stop there (first pass)
G1 H2 Z2 F200     ; go back a few mm
G1 H4 Z-4 F100    ; move slowly to Z axis endstop once more (second pass)
G1 H2 Z{13 + 2.25} F12000  ; move to the klicky dock height (z=13 accounting for button height)
G90               ; absolute positioning

; Move to a location that will be safe to activate the servo
; but also close to where we want to be

M98 P"/sys/rapid-move.g" X{global.klicky_release_x} Y{global.klicky_release_y}
