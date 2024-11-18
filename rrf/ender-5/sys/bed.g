T0
G1 Z5

M401

var i = 0
while i < # global.bed_probe_points - 1
  G30 P{var.i} X{global.bed_probe_points[var.i][0]} Y{global.bed_probe_points[var.i][1]} Z-99999
  set var.i = var.i + 1

if # global.bed_probe_points > 0
  G30 P{var.i} X{global.bed_probe_points[var.i][0]} Y{global.bed_probe_points[var.i][1]} Z-99999 S{var.i+1}

M402
