set global.print_ended_x = move.axes[0].max - 1
set global.print_ended_y = move.axes[1].max - 1

set global.bed_middle_x = 300
set global.bed_probe_points = { {150, 150}, {150, 450}, {450, 450}, {450, 150} }
set global.bed_meshing_max_stddev = 0.075

; PZ Probe on setting #2
set global.probe_is_klicky = false
set global.probe_at_temperature_delta = 70

set global.use_mesh_compensation = true
set global.use_true_bed_leveling = true

set global.wipe_x_range = {622, 618}
set global.wipe_y_range = {305, 355}
set global.wipe_safe_x = 615
set global.wipe_at_x = global.wipe_x_range[0]
set global.wipe_at_y = global.wipe_y_range[0]
set global.wipe_park_x = move.axes[0].max - 1
