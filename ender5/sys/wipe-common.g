T-1

G1 X{global.xMin+25} U{global.uMax-25} F24000 ; move beside the bucket
G1 Y-30 F24000              ; past the wiping bucket
G1 X{global.xMin+1} U{global.uMax-1} F24000  ; now over the bucket

T{param.T}

if exists(param.E) then
  G1 E{param.E} F300          ; 5mm/sec prime
else
  G1 E10 F300

if exists(param.R) then
  G1 E{-param.R} F1800        ; 30mm/sec retract
else
  G1 E-1 F1800
  
G1 Y0 F12000