set global.bed_middle_x = 112.5
set global.bed_middle_y = 112.5

set global.print_ended_y = move.axes[1].max - 1

set global.bed_probe_points = { { 110, 30}, {195, 195}, {30, 195} }
set global.bed_meshing_max_stddev = 0.04

set global.probe_is_klicky = false
set global.probe_at_temperature_delta = 50

set global.use_mesh_compensation = false
set global.use_true_bed_leveling = true

set global.wipe_x_range = { -36, -32 }
set global.wipe_y_range = {-15, 15}
set global.wipe_safe_x = -28
set global.wipe_safe_u = 255
set global.wipe_at_x = global.wipe_x_range[0]
set global.wipe_at_u = 260
set global.wipe_at_y = global.wipe_y_range[0]
set global.wipe_park_x = move.axes[0].min + 1
set global.wipe_park_u = move.axes[3].max - 1
