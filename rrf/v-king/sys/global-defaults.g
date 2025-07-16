set global.print_ended_x = -50
set global.print_ended_y = 370
set global.print_ended_z = 5

set global.bed_probe_points = { {175, 75}, {75, 125}, {275, 125}, {(move.axes[0].max - move.axes[0].min + 1) / 2, (move.axes[1].max - move.axes[1].min + 1) / 2}, {275, 300}, {175, 300}, {75, 300} }
set global.bed_meshing_max_stddev = 0.05

set global.probe_at_temperature_delta = 50

set global.use_mesh_compensation = true
set global.use_true_bed_leveling = true

set global.wipe_y_range = {200, 250}
set global.wipe_at_x = -6
