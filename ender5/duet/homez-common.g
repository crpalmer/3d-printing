G1 H2 Z5 F6000    ; lift Z relative to current position
G1 H1 Z-310 F360  ; move Z down until the endstop is triggered
G1 Z2             ; move down a little bit
G1 H1 Z-5 F30     ; slow second pass

; adjust if the bed leveling is too close or too far
G1 Z-0.675 F360 ; -0.65 was just a little too close?

; Make the current position 0 (for some reason just doing G92 Zx instead of G1 Zx ; G92 Z0 isn't working)
G92 Z0
