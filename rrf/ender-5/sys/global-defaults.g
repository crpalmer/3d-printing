set global.bed_middle_x = 112.5
set global.bed_middle_y = 112.5

set global.print_ended_y = move.axes[1].max - 1

set global.bed_probe_points = { { 110, 30}, {195, 200}, {30, 200} }

set global.probe_servo = 1
set global.klicky_pre_x = 113.8
set global.klicky_pre_y = 180
set global.klicky_dock_x = global.klicky_pre_x
set global.klicky_dock_y = 220
set global.klicky_release_x = global.klicky_dock_x - 50
set global.klicky_release_y = global.klicky_dock_y
set global.klicky_servo_up = 1660
set global.klicky_servo_down = 575

set global.probe_is_klicky = false
set global.probe_at_temperature_delta = 50

set global.use_mesh_compensation = false
set global.use_true_bed_leveling = true

set global.wipe_y_range = {-25, 25}
set global.wipe_safe_x = -28
set global.wipe_safe_u = 255
set global.wipe_at_x = -34
set global.wipe_at_u = 260
set global.wipe_at_y = -25
set global.wipe_park_x = move.axes[0].min + 1
set global.wipe_park_u = move.axes[3].max - 1
