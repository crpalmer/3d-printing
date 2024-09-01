G91                           ; relative positioning
G1 H2 Z5 F6000                ; lift Z relative to current position
G1 H1 X+650 Y+650 F1800       ; move quickly to X and Y axis endstops and stop there (first pass)
G1 H2 X-5 Y-5 F6000           ; go back a few mm
G1 H1 X+10 Y+10 F360          ; move slowly to X and Y axis endstops once more (second pass)
G90                           ; absolute positioning
