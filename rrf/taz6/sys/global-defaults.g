set global.print_ended_x = move.axes[0].min + 1
set global.print_ended_y = move.axes[1].max - 1

set global.bed_probe_points = { {5, 140}, {275, 140} }
set global.bed_middle_x = 150 - global.zprobe_offset_x
set global.bed_middle_y = 150 - global.zprobe_offset_y

set global.probe_servo = 0
set global.klicky_pre_x = -1
set global.klicky_pre_y = -10
set global.klicky_pre_z = 13
set global.klicky_pre_dock_script = "/sys/klicky-pre-dock.g"
set global.klicky_dock_x = global.klicky_pre_x
set global.klicky_dock_y = 18
set global.klicky_release_x = global.klicky_dock_x + 50
set global.klicky_release_y = global.klicky_dock_y
set global.klicky_servo_up = 1350
set global.klicky_servo_down = 2050
