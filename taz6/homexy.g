G91                     ; relative positioning
G1 H2 Z5 F6000          ; lift Z relative to current position
G1 H1 X-305 Y308 F1800  ; move quickly to X and Y axis endstops and stop there (first pass)
G1 H2 X5 Y-5 F6000      ; go back a few mm
G1 H1 X-305 Y308 F360   ; move slowly to X and Y axis endstops once more (second pass)
G90