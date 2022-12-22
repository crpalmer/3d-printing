G91
G1 H2 Z5 F6000    ; lift Z relative to current position
G90
;G1 X170 Y150 F6000      ; move to the middle offset by the probe distance
G1 X{(global.brX - global.blX) / 2 + global.blX - global.blTouchX} Y{(global.frontY - global.blrY) / 2 + global.blrY + global.blTouchY} F24000
G30