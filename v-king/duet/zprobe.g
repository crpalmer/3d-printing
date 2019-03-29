M558 P4 H5 T3000 I1 R0.5 A30 S0.01	   ; configure piezo probe (would be P5 (or P8?) on z probe)
G31 P500 X0 Y0 Z-0.03			   ; probe sensitivity and offset
; (probe is really -0.06 but the center is a little low so try to get close on the whole bed by being a little too low on the edges)