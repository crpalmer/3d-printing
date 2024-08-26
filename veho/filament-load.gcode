M83
G1 E200 F600      ; Quickly push through all enough filament to prime the nozzle
G1 E10 F60        ; Slowly push out a little more to try to stop back-pressure
G1 E-1 F18000     ; Retract to match what "Resume" will do
