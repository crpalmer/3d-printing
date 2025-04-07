set global.print_ended_x = move.axes[0].max - 1
set global.print_ended_y = move.axes[1].max - 1

set global.bed_middle_x = 300
set global.bed_probe_points = { {100, 100}, {100, 500}, {500, 500}, {500, 100} }

; TO REMOVE
set global.klicky_is_manual = true
set global.klicky_pre_x = move.axes[0].max - 1
set global.klicky_pre_y = 200

; WHEN I INSTALL PZ PROBE
;set global.probe_is_klicky = false
set global.probe_at_temperature_delta = 50

set global.use_mesh_compensation = true
set global.use_true_bed_leveling = true

set global.wipe_y_range = {305, 355}
set global.wipe_safe_x = 615
set global.wipe_at_x = 620.5
set global.wipe_at_y = global.wipe_y_range[0]
set global.wipe_park_x = move.axes[0].max - 1
