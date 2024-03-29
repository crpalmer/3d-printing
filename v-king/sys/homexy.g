G91                    ; relative positioning
G1 Z2 F6000 H2         ; lift Z relative to current position
G1 H1 X-345 Y+385 F1800 ; move quickly to X or Y endstop and stop there (first pass)
G1 H1 X-345            ; home X axis
G1 H1 Y-385            ; home Y axis
G1 H2 X5 Y-5 F6000     ; go back a bit
G1 H1 X-10 F360        ; move slowly to X axis endstop once more (second pass)
G1 H1 Y+10 F360        ; then move slowly to Y axis endstop
G90                    ; absolute positioning