set global.print_ended_x = move.axes[0].min + 1
set global.print_ended_y = move.axes[1].max - 1

set global.bed_probe_points = { {5, 140}, {275, 140} }
set global.bed_middle_x = 150 - global.zprobe_offset_x
set global.bed_middle_y = 150 - global.zprobe_offset_y
