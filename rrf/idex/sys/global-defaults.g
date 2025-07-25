set global.print_ended_y = 370

set global.bed_middle_x = 150
set global.bed_middle_y = 178

set global.bed_probe_points = { {global.bed_middle_x, 50}, {global.bed_middle_x, 300} }

; PZ Probe on setting #2
set global.probe_at_temperature_delta = 50

set global.use_mesh_compensation = true
set global.use_true_bed_leveling = true

; TODO: use wipe_x/u_range
set global.wipe_at_y = 150
set global.wipe_y_range = {global.wipe_at_y - 50, global.wipe_at_y}
set global.wipe_at_x = move.axes[0].max - 3
set global.wipe_x_range = {global.wipe_at_x - 2.5, global.wipe_at_x + 2.5}
set global.wipe_at_u = move.axes[3].min + 3.5
set global.wipe_u_range = {global.wipe_at_u - 3, global.wipe_at_u + 3}
set global.wipe_park_x = move.axes[0].max - 1
set global.wipe_park_u = move.axes[3].min + 1
