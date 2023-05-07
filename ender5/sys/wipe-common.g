T-1

var base_mm = 3
var extra_mm = 3
var multiplier = 0
var retract = 1

G1 X{global.xMin+25} U{global.uMax-25} F24000 ; move beside the bucket
G1 Y{global.yMin+7} F24000              ; past the wiping bucket
G1 X{global.xMin+1} U{global.uMax-1} F24000  ; now over the bucket
; G1 Y{global.yMin+12} F24000              ; close to the silicone pad

T{param.T}

if exists(param.E) then
  if param.E > 0 then
     set var.base_mm = param.E

if exists(param.R) then
  if param.R > 0 then
     set var.retract = param.R

if exists(param.X) then
  if param.X > 0 then
     set var.extra_mm = param.X
	 
if exists(param.S) then
  if param.S > 480
     set var.multiplier = 3
  elif param.S > 120
     set var.multiplier = 2
  elif param.S > 10
     set var.multiplier = 1

; echo var.base_mm + var.multiplier*var.extra_mm
G1 E{var.base_mm + var.multiplier*var.extra_mm} F180 ; F300
G1 E{-var.retract} F1800

G1 Y0 F24000

; Wait for moves to finish before returning
M400